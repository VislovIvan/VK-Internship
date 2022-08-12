# VK Internship 2022 photos
Vislov Ivan, Saint-Petersburg

#### Задание выполнил на SwiftUI
- [x] Регистрация 
- [x] Разлогин
- [x] Обработка ошибок и показ их пользователю
- [x] Выбор аватарки 
- [x] Список всех пользователей с аватарками
- [x] Редактирвания фотографии из медиатеки и из локальных альбомов
- [x] Сохранение отредактированной фотографий в медиатеку
- [x] Фотографии из API unsplash
- [x] Открытие фотографии пользователей в полный экран
- [x] Если залогинился, то экран входа не показывается повторно

- [ ] Не добавил распознование лица для фотографий и область видимости
- [ ] Редактирование изображения из API

### [Видео работы приложения](https://youtu.be/q06AINrhXrk)

#### Дополнительно + сборка проекта с нуля: 
###### Для выполнения задания я использовал Firebase Authentication, знаю, что в задании, написано про локальная БД. Приложение полностью на SwiftUI, использовал Firebase для ускорения работы, так как ответ на вопрос по поводу БД от поддержки получил поздно. И не успел реализовать сохранение данных локально. 
###### Область видимости хотел реализовать через Vision Kit от Apple, но немного не успел его адаптировать для SwiftUI.
##### Сборка с нуля: 
- [GitHub Firebase](https://github.com/firebase/firebase-ios-sdk) + файл GoogleService-Info для связи с Firebase (3 package pruduct: FirebaseAuth, FirebaseStorage и FirebaseFirestore)
<img width="1552" alt="3" src="https://user-images.githubusercontent.com/74829720/162598313-f6ac669f-bf6e-4f37-8075-5223e26f7aec.png">
<img width="1552" alt="1" src="https://user-images.githubusercontent.com/74829720/162598316-4832eed8-c58f-4ec8-97bc-a6c2c7f5be07.png">
<img width="1552" alt="4" src="https://user-images.githubusercontent.com/74829720/162598319-5d113d32-35a8-49cb-a3e6-361f2982cfd6.png">
<img width="1552" alt="5" src="https://user-images.githubusercontent.com/74829720/162598325-604c0c31-5d01-40b9-af35-01af8138d25d.png">
<img width="1552" alt="6" src="https://user-images.githubusercontent.com/74829720/162598363-282349ea-76a9-4ee7-96e9-5378ba07fd19.png">

- [GitHub SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI) для работы с изображениями из сети

- Pods: 
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'FirebaseFirestoreSwift'
pod 'Firebase/Storage'
<img width="794" alt="2" src="https://user-images.githubusercontent.com/74829720/162598377-c1ca8b20-4c87-4245-9651-96ae59afd944.png">

- Скачал и собрал проект с нуля. Библиотеки рабочие, проект запустился. Сам проект лучше запускать через симулятор, так как сохранение изображения и добавление текста в редакторе могут некорректно работать в самом XCode.
## [telegram](https://t.me/vangog101)
