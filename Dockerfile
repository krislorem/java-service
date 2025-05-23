#FROM openjdk:17-slim AS build
#ENV HOME=/usr/app
#RUN mkdir -p HOME
#WORKDIR $HOME
#ADD . WORKDIR
#COPY .mvn .mvn
#COPY mvnw pom.xml ./
#RUN chmod +x ./mvnw
#RUN --mount=type=cache,target=/root/.m2 ./mvnw -f $HOME/pom.xml clean package
#
#FROM openjdk:17-slim
#ARG JAR_FILE=/usr/app/target/*.jar
#COPY --from=build $JAR_FILE /app/runner.jar
#EXPOSE 8081
#ENTRYPOINT java -jar /app/runner.jar
# 构建阶段
FROM openjdk:17-slim AS build
ENV HOME=/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME
ADD . $HOME
RUN chmod +x ./mvnw
RUN --mount=type=cache,target=/root/.m2 ./mvnw -f $HOME/pom.xml clean package

# 打包阶段
FROM openjdk:17-slim
ARG JAR_FILE=/usr/app/target/*.jar
COPY --from=build $JAR_FILE /app/runner.jar
EXPOSE 8081
ENTRYPOINT java -jar /app/runner.jar
