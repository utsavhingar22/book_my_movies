# **Book My Movies**

## **📌 Overview**
This Flutter application allows users to:
- View a **paginated list of users** from the ReqRes API.
- **Add new users** with offline support using Hive.
- Automatically **sync offline users** with the API when the device is online.
- **View trending movies** from The Movie Database (TMDB).
- Navigate to **movie details** with descriptions and poster images.

The app is built with **Riverpod** for state management, **Dio** for networking, **Hive** for local storage, and **WorkManager** for background tasks.

---

## **🚀 Features**
### **1️⃣ User List Screen**
✔️ Fetch and display paginated users from **ReqRes API**.  
✔️ Show **first name, last name, and avatar image**.  
✔️ Implement **pagination** to load more users as the user scrolls.  
✔️ Clicking a user navigates to the **Movie List Screen**.

### **2️⃣ Add User Screen**
✔️ Navigate to an **"Add User"** screen with a Floating Action Button (FAB).  
✔️ **Online Mode** → User is **immediately posted** to ReqRes API.  
✔️ **Offline Mode** → User is **stored locally in Hive** and synced later.  
✔️ **WorkManager** syncs offline users **automatically** when online.

### **3️⃣ Movie List Screen**
✔️ Fetch and display paginated **trending movies** from TMDB API.  
✔️ Show **poster image, title, and release date**.  
✔️ Clicking a movie navigates to the **Movie Detail Screen**.

### **4️⃣ Movie Detail Screen**
✔️ Fetch detailed movie information using **TMDB API**.  
✔️ Display **title, description, release date, and poster image**.

---

## **🛠️ Tech Stack**
| Feature          | Library/Tool |
|-----------------|-------------|
| **State Management** | Riverpod |
| **Networking** | Dio |
| **Local Storage** | Hive |
| **Offline Sync** | WorkManager |
| **Navigation** | GoRouter |
| **Image Loading** | CachedNetworkImage |
| **Pagination** | Infinite Scroll |

---

## **📂 Project Structure**
```
lib/ 
│── data/ 
    │ ├── api_service.dart # Handles API calls using Dio 
    │ ├── local_storage.dart # Handles local storage using Hive 
    │ ├── user_notifier.dart # Manages user state with Riverpod 
│ │── models/ 
    │ ├── movie_model.dart # Model for Movie API data │ 
    ├── user_model.dart # Model for User API data │ 
│── providers/ 
    │ ├── movie_provider.dart # Manages movie data fetching 
    │ ├── user_provider.dart # Manages user data fetching 
│ │── screens/ 
    │ ├── add_user_screen.dart # Add User UI 
    │ ├── movie_list_screen.dart # Movie List UI 
    │ ├── movie_detail_screen.dart # Movie Detail UI 
    │ ├── user_list_screen.dart # User List UI │ │── widgets/ 
    │ ├── user_card.dart # UI component for displaying a user 
    │ ├── movie_card.dart # UI component for displaying a movie 
│ └── main.dart # App entry point
```
---

## Installation & Setup
1. **Clone the Repository:**
   ```sh
   git clone https://github.com/utsavhingar22/book_my_movies.git
   cd flutter_movies_app
   ```
2. **Install Dependencies:**
   ```sh
   flutter pub get
   ```
3. **Run the App:**
   ```sh
   flutter run
   ```

## Author
Utsav Hingar

---
*Happy Coding! 🚀*
