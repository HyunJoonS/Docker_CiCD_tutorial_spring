# 첫 번째 스테이지: Gradle을 사용하여 JAR 파일을 빌드합니다.
FROM gradle:7.5-jdk17 AS build

# 작업 디렉토리 설정
WORKDIR /app

# Gradle 프로젝트 파일을 복사합니다.
COPY build.gradle settings.gradle ./
COPY src ./src

# JAR 파일을 빌드합니다.
RUN gradle clean build --no-daemon

# 두 번째 스테이지: Amazon Corretto JDK 17을 사용하여 최종 이미지를 만듭니다.
FROM amazoncorretto:17-alpine-jdk

# 작업 디렉토리 설정
WORKDIR /app

# 첫 번째 스테이지에서 빌드된 JAR 파일을 복사합니다.
COPY --from=build /app/build/libs/*.jar /app/app.jar

# 애플리케이션이 사용하는 포트를 노출합니다.
EXPOSE 8080

# 애플리케이션을 실행합니다.
ENTRYPOINT ["java", "-jar", "/app/app.jar"]