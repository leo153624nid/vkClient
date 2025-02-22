Приложение Вконтакте клиент

Необходимо написать клиент для социальной сети Вконтакте.

Требования к приложению:

1. Экран входа в вк аккаунт
2. Экран с новостной лентой пользователя: например,для каждой записи
  показывать аватар автора, дату и текст
3. Экран с деталями поста: например, показывать, прикрепленные
  картинки, текст и количество лайков
4. Возможность поставить|убрать лайк к записи
 
Дизайн

Решения о дизайне остаются полностью на ваше усмотрение.

Примечания
1. Задание нужно выполнять на Swift.
2. Выполненное задание нужно загрузить на github и отправить решение нам.

Разбор тестового задания

В качестве тестового задания было предложено создать мобильный клиент для социальной сети VK. Мы не ограничивали кандидатов в выборе стека технологий, предоставляя возможность использовать любые современные подходы и инструменты для написания кода. Единственным исключением был язык программирования Swift, который мы используем на нашем проекте.

На что мы обращали внимание при проверке тестового задания:

Чистота кода:

● Использование понятных имен для переменных, функций, классов и модулей;

● Избегание дублирования кода путем выделения общих частей в отдельные функции или классы.

Архитектура проекта:

● В проекте возможно использовать как одномодульную, так и многомодульную архитектуру. Главный аспект – это разделение проекта на модули и пакеты;

● Применение подхода Clean Architecture для разделения уровней приложения на слои: Data, Domain и Presentation;

● Использование архитектурных паттернов в Presentation слое. Здесь можно выбрать одну из архитектур: MVP, MVVM или MVI;

● Применение различных инструментов для внедрения зависимостей (DI) и организация графа зависимостей в проекте.

Функционал описанный в требованиях:

● Весь функционал описанный в требованиях реализован;

● Отсутствуют краши и необработанные состояния при работе приложения. Обработка ошибок:

● Обработаны события при сетевых запросах (отображение понятного текста ошибки и возможность повторить запрос);

● Использование заглушек (stub состояний), например, при отсутствии интернет-соединения

Плюсом будет

● Не использовать VK SDK

● Обработка случаев, когда нет интернета

● Приятный минималистичный UI
