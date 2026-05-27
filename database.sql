-- ============================================
-- База данных: Пассажирам.РФ
-- Курсы обучения водителей пассажирского транспорта
-- ============================================

CREATE DATABASE IF NOT EXISTS passazhiram CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE passazhiram;

-- --------------------------------------------
-- Таблица: Виды транспорта
-- --------------------------------------------
CREATE TABLE transport_types (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO transport_types (name) VALUES
    ('Автобус'),
    ('Электробус'),
    ('Трамвай');

-- --------------------------------------------
-- Таблица: Способы оплаты
-- --------------------------------------------
CREATE TABLE payment_methods (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO payment_methods (name) VALUES
    ('Наличными'),
    ('Банковской картой'),
    ('Банковский перевод');

-- --------------------------------------------
-- Таблица: Статусы заявок
-- --------------------------------------------
CREATE TABLE statuses (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO statuses (name) VALUES
    ('Новая'),
    ('Идет обучение'),
    ('Обучение завершено');

-- --------------------------------------------
-- Таблица: Пользователи
-- --------------------------------------------
CREATE TABLE users (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    login      VARCHAR(50)  NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    lastname   VARCHAR(100) NOT NULL,
    firstname  VARCHAR(100) NOT NULL,
    middlename VARCHAR(100) NOT NULL,
    dob        DATE         NOT NULL,
    phone      VARCHAR(20)  NOT NULL,
    email      VARCHAR(150) NOT NULL,
    is_admin   TINYINT(1)   NOT NULL DEFAULT 0,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Администратор (логин: Admin26, пароль: Demo20)
INSERT INTO users (login, password, lastname, firstname, middlename, dob, phone, email, is_admin)
VALUES ('Admin26', 'Demo20', 'Администратор', 'Система', '', '2000-01-01', '+70000000000', 'admin@passazhiram.rf', 1);

-- --------------------------------------------
-- Таблица: Заявки на обучение
-- --------------------------------------------
CREATE TABLE applications (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT  NOT NULL,
    transport_id INT  NOT NULL,
    payment_id   INT  NOT NULL,
    status_id    INT  NOT NULL DEFAULT 1,
    start_date   DATE NOT NULL,
    created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)      REFERENCES users(id)            ON DELETE CASCADE,
    FOREIGN KEY (transport_id) REFERENCES transport_types(id)  ON DELETE RESTRICT,
    FOREIGN KEY (payment_id)   REFERENCES payment_methods(id)  ON DELETE RESTRICT,
    FOREIGN KEY (status_id)    REFERENCES statuses(id)         ON DELETE RESTRICT
);

-- --------------------------------------------
-- Таблица: Отзывы
-- --------------------------------------------
CREATE TABLE reviews (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT  NOT NULL,
    application_id INT  NOT NULL UNIQUE,
    content        TEXT NOT NULL,
    created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)        REFERENCES users(id)        ON DELETE CASCADE,
    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE
);

-- ============================================
-- Тестовые данные
-- ============================================

INSERT INTO users (login, password, lastname, firstname, middlename, dob, phone, email)
VALUES
    ('ivanov01', 'password1', 'Иванов', 'Иван', 'Иванович', '1995-03-15', '+79001112233', 'ivanov@mail.ru'),
    ('petrov02', 'password2', 'Петров', 'Пётр', 'Петрович', '1990-07-22', '+79004445566', 'petrov@mail.ru');

INSERT INTO applications (user_id, transport_id, payment_id, status_id, start_date) VALUES
    (2, 1, 2, 1, '2026-06-01'),
    (3, 3, 1, 2, '2026-05-10'),
    (2, 2, 3, 3, '2026-04-01');

INSERT INTO reviews (user_id, application_id, content) VALUES
    (2, 3, 'Отличные курсы! Инструктор объяснял всё понятно, сдал с первого раза.');
