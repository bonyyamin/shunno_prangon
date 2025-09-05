# Shunno Prangon (শূন্য প্রাঙ্গণ)

**Motto:** Connecting minds, one star at a time. (এক নক্ষত্রে মনের মিলন।)

Shunno Prangon, which translates to **"Courtyard of the Void,"** is a cosmic blogging and article-reading mobile application designed for the Bangladeshi community. Our mission is to create a community space for sharing knowledge and ideas about the universe, from galaxies and black holes to the fundamentals of physics and chemistry.

The app provides a platform for passionate writers and curious readers to explore the wonders of the cosmos in their native language, Bengali.

-----

## Key Features

  * **User-Friendly Interface:** A clean, dark, and visually appealing design inspired by the night sky. The intuitive user experience makes it simple to navigate between reading and writing articles.
  * **Powerful Writing Tools:** The in-app editor is designed for a seamless writing experience. Users can format text, add headers, insert images, and organize their thoughts with a straightforward and elegant interface.
  * **Explore and Discover:** A dynamic home feed, curated to highlight trending and recent articles, keeps users updated with fresh content. The robust search functionality allows for filtering by authors, topics, or specific keywords.
  * **Personalized User Profiles:** Each user gets a dedicated profile page to showcase their published work, a short bio, and their contributions to the community. This builds a sense of identity and encourages more engagement.
  * **Bangla Localization:** The entire application is meticulously localized for the Bengali language, including text, dates, and number formats. This ensures a comfortable and accessible experience that truly feels native to the Bangladeshi audience.
  * **Real-time Engagement:** Articles can be updated in real-time. Future updates will introduce interactive features such as commenting, upvoting, and saving articles for offline reading, fostering a lively and engaging community.

-----

## Technology Stack

  * **Frontend:** Flutter
  * **Architecture:** Clean Architecture
  * **State Management:** Riverpod
  * **Data Models:** Freezed
  * **Backend:** Firebase (Authentication, Cloud Firestore, and Cloud Storage)

-----

## Getting Started

This guide will help you set up and run the Shunno Prangon app on your local machine.

### Prerequisites

  * **Flutter SDK:** Ensure you have the Flutter SDK installed and configured.
  * **Firebase CLI:** You need to have the Firebase Command Line Interface installed globally.
  * **Code Editor:** Visual Studio Code or Android Studio with the Flutter and Dart plugins.

### Setup

1.  **Clone the Repository:**

    ```bash
    git clone [repository-url]
    cd shunno_prangon
    ```

2.  **Install Dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Firebase Configuration:**

      * Create a new project in the **Firebase Console**.
      * Enable **Firebase Authentication, Firestore, and Storage**.
      * From your terminal, run `flutterfire configure` and follow the prompts to connect your Flutter app to your Firebase project. This will generate the necessary `firebase_options.dart` file.

4.  **Run the App:**

    ```bash
    flutter run
    ```

-----

## Contribution

We welcome contributions from the community\! If you'd like to contribute, please feel free to fork the repository, make your changes, and submit a pull request. We are always looking for help with bug fixes, new features, and design improvements. Your feedback and ideas are invaluable to the success of this project.