# --- Estágio 1: Build ---
# Usamos uma imagem oficial do Maven que já contém o JDK 17 para compilar a aplicação.
# O nome 'build' é um apelido para este estágio.
FROM maven:3.8.5-openjdk-17 AS build

# Define o diretório de trabalho dentro do contêiner.
WORKDIR /app

# Copia primeiro o pom.xml para aproveitar o cache de camadas do Docker.
# Se as dependências não mudarem, o Docker não precisará baixá-las novamente.
COPY pom.xml .

# Baixa todas as dependências do projeto.
RUN mvn dependency:go-offline

# Copia todo o resto do código-fonte do projeto.
COPY src ./src

# Compila a aplicação e gera o arquivo .jar, pulando os testes para acelerar o build.
RUN mvn package -DskipTests


# --- Estágio 2: Run ---
# Usamos uma imagem base do OpenJDK 17 que é muito menor, pois não contém
# as ferramentas de build (Maven), apenas o necessário para executar a aplicação.
FROM openjdk:17-jdk-slim

# Define o diretório de trabalho.
WORKDIR /app

# Copia o arquivo .jar que foi gerado no estágio 'build' para o nosso estágio final.
# O caminho do .jar é padronizado pelo Spring Boot.
COPY --from=build /app/target/conta-service-0.0.1-SNAPSHOT.jar ./app.jar

# Expõe a porta 8080 (ou a porta que seu serviço usa internamente).
# O Railway irá mapear uma porta pública para esta porta interna.
EXPOSE 8080

# Comando que será executado quando o contêiner iniciar.
# Inicia a aplicação Java.
ENTRYPOINT ["java", "-jar", "app.jar"]