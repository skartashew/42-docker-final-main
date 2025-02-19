# Этап сборки
FROM golang:latest as build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы go.mod и go.sum для загрузки зависимостей
COPY go.mod go.sum ./

# Загружаем зависимости
RUN go mod download

# Копируем исходный код в контейнер
COPY . .

# Собираем приложение
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o todo-app .

# Финальный образ
FROM alpine:latest

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранное приложение из этапа сборки
COPY --from=build /app/todo-app .

# Копируем файл базы данных
COPY tracker.db .

# Указываем команду для запуска приложения
CMD ["./todo-app"]