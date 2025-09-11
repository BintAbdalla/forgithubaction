# =========================
# Étape 1 : Build de l'application
# =========================
FROM node:20-alpine AS builder

WORKDIR /app

# Copier seulement les fichiers nécessaires pour installer les dépendances
COPY package.json package-lock.json* ./

# Installer les dépendances
RUN npm install

# Copier tout le projet
COPY . .

# Construire l'application
RUN npm run build

# =========================
# Étape 2 : Serveur Nginx pour servir l'application
# =========================
FROM nginx:alpine

# Supprimer le contenu par défaut de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copier le build final depuis l'étape builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copier une configuration Nginx personnalisée (optionnel)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port 80
EXPOSE 80

# Lancer Nginx
CMD ["nginx", "-g", "daemon off;"]
