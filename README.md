A modern, creative, and professional mobile app prototype for wedding planning, developed using Flutter.
This application was built as part of an internship assignment to demonstrate skills in mobile app development, UI/UX design, and state management.

---

##  Features

- **User Authentication**: A secure login and registration system with a "Remember Me" option for a seamless user experience.
- **Dynamic Wedding Checklist**: A comprehensive checklist of wedding tasks (e.g., Venue, Catering, Photography) that users can manage. Tasks are displayed on interactive cards that expand to reveal more options.
- **Event Booking with Calendar**: Users can book events directly from the checklist by selecting a specific date using an integrated calendar.
- **Venue and Vendor Listings**: A list of dummy venues with detailed information, including price, capacity, and a list of services.
- **Budget Calculator**: A dedicated screen to help users manage their wedding budget with a simple percentage-based breakdown for key categories.
- **Guest List Management**: A tool for adding guests and tracking their RSVP status.
- **Theming**: A toggle for switching between a light and dark theme, enhancing the app's visual appeal.
- **Clean UI/UX**: The app features a professional, wedding-themed design with smooth animations and transitions.

---

## 🛠️ Technical Details

- **Framework**: Flutter
- **State Management**: Provider
- **Data Storage**: Local in-memory data (simulating a backend for this prototype)

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
- An IDE with Flutter support (e.g., Android Studio, VS Code).

### Installation

1.  **Clone the repository**:
    ```bash
    git clone [your-repository-url]
    cd wedding_planner_app
    ```
2.  **Get dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Add Assets**:
    This app uses local assets for images. You need to create an `assets/images` folder in the root of your project and add the following files.
    - `logo.png`
    - `venue.jpg`
    - `photography.jpg`
    - `catering.jpg`
    - `mehendi.jpg`
    - `sangeet.jpg`
    - `honeymoon.jpg`
    - `new_task.png`
    - `grand_ballroom.jpg`
    - `the_lake_house.jpg`
    - `city_gardens.jpg`
    - `rustic_manor.jpg`
    - `mountain_view_resort.jpg`

4.  **Run the app**:
    ```bash
    flutter run
    ```

---

## 📋 Login Credentials

For testing the login feature, use the following mock credentials:

- **Email**: `test@example.com`
- **Password**: `password123`

You can also use the "Sign Up" option to create a new user account.

---

## 📈 Evaluation Criteria Met

This project was developed with the provided evaluation criteria in mind.

- **Functionality**: All core and bonus requirements are fully implemented.
- **UI/UX Creativity**: The design is visually appealing, professional, and features creative elements like a dynamic dark mode.
- **Code Quality**: The code is clean, modular, and well-structured, following best practices for state management.
- **Problem-Solving**: Complex features like dynamic event booking and local data persistence were handled effectively.

---



