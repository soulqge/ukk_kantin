# UKK Kantin App

UKK Kantin is a Flutter-based mobile application designed for a school canteen. It allows students to browse menus, filter items by food stalls (*stan*), view item details, and place orders conveniently.

## Features

- 🔐 **User Authentication**
  - Login system for students and staff
- 👋 **Personalized Greetings**
  - Displays logged-in user name
- 🔍 **Search Bar**
  - Real-time search filtering of menu items
- 🍽️ **Menu Browsing**
  - Categorized into **Makanan**, **Minuman**, and **All**
- 🧑‍🍳 **Stan (Food Stall) Filtering**
  - View menus by stall (each item linked to a specific `stanId`)
- 📄 **Detail Menu Page**
  - View image, category, and formatted price
- 🛒 **Cart Functionality**
  - Add items to cart and proceed to checkout
- 🚫 **Empty State Handling**
  - Graceful handling when no menu items are available

## Technologies Used

- **Flutter** & **Dart**
- **Shared Preferences** – for user session persistence
- **Google Fonts** – custom fonts for UI
- **Intl** – for formatting prices (e.g., `Rp`)
- **RESTful API** – menu data fetched from backend
- **Image Handling** – displays network or placeholder images


## How to Run

1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Connect a device or emulator.
4. Run the app using `flutter run`.

## TODO

- [ ] Add user profile editing
- [ ] Add stan profile editing
- [ ] Add stan menu editing
- [ ] Add discount implementation
- [ ] Improve UI with animations
- [ ] Add unit & widget tests

---


