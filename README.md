# CysterEase

## Overview

CysterEase is a Flutter-based mobile application designed to support women managing Polycystic Ovary Syndrome (PCOS) and Polycystic Ovarian Disease (PCOD). The application provides health-tracking and wellness management tools that help users monitor lifestyle factors associated with PCOS, including diet, sleep, stress, physical activity, and menstrual health.

The goal of CysterEase is to offer an accessible digital platform that encourages healthy habits, improves awareness of hormonal health, and supports long-term wellness management.

---

## Problem Statement

Women with PCOS/PCOD often struggle to consistently monitor and manage various aspects of their health, including nutrition, menstrual cycles, sleep quality, stress levels, and physical activity. Existing solutions may not provide a comprehensive, PCOS-focused approach.

CysterEase addresses this challenge by integrating multiple wellness tools into a single application specifically tailored for PCOS/PCOD management.

---

## Objectives

- Provide personalized PCOS-friendly diet recommendations.
- Track sleep patterns and promote healthy sleep habits.
- Help users monitor menstrual cycles and symptoms.
- Support stress management through wellness resources.
- Encourage physical activity through guided workout plans.
- Store and manage user health data securely using Firebase.

---

## Features

### User Authentication
- User registration and login
- Firebase Authentication integration
- Secure account management

### Dashboard
- Centralized access to all wellness modules
- User-friendly navigation interface

### Diet Planner
Provides PCOS-friendly meal plans categorized by health goals:

- Weight Loss
- Weight Gain
- Hormonal Balance
- Energy Boost
- Fertility Support

Each plan includes:
- Weekly meal schedules
- Breakfast, lunch, snacks, and dinner recommendations
- Calorie information
- Health benefits
- Food illustrations

### Sleep Tracker
- Sleep duration calculation
- Sleep log management
- Historical sleep records
- Sleep trend visualization
- Firebase data storage

### Period Tracker
- Period cycle logging
- Symptom tracking
- Mood tracking
- Flow intensity tracking
- Pain level monitoring
- Energy level monitoring
- Cycle history management
- Personalized insights

### Workout Planner
- PCOS-friendly exercise recommendations
- Physical activity guidance
- Wellness-focused workout routines

### Stress Management Tools
- Relaxation resources
- Wellness guidance
- Mental health support content

### Educational Resources
- Curated health articles related to:
  - PCOS
  - Nutrition
  - Exercise
  - Sleep
  - Hormonal health

---

## System Architecture

The application follows a modular Flutter architecture:

- UI Layer
- Business Logic Layer
- Firebase Services Layer
- Cloud Firestore Database

### Major Components

- Authentication Module
- Dashboard Module
- Diet Planner Module
- Sleep Tracker Module
- Period Tracker Module
- Workout Planner Module
- Stress Management Module

---

## Technology Stack

### Frontend
- Flutter
- Dart

### Backend Services
- Firebase Authentication
- Cloud Firestore

### Packages Used
- firebase_auth
- cloud_firestore
- fl_chart
- table_calendar
- url_launcher
- intl

---

## Database

### Firebase Firestore Collections

#### Users
Stores user account information.

#### Sleep Logs
Stores:
- Sleep time
- Wake-up time
- Sleep duration
- Timestamp

#### Period Logs
Stores:
- Period dates
- Symptoms
- Mood
- Pain level
- Energy level
- Flow intensity
- Notes

---

## Installation

### Prerequisites

- Flutter SDK
- Android Studio / VS Code
- Firebase Project
- Android Emulator or Physical Device

### Steps

1. Clone the repository

```bash
git clone https://github.com/pava0206/CysterEase.git
```

2. Navigate to project directory

```bash
cd CysterEase
```

3. Install dependencies

```bash
flutter pub get
```

4. Configure Firebase

- Create a Firebase project
- Enable Authentication
- Enable Cloud Firestore
- Add the Firebase configuration files

5. Run the application

```bash
flutter run
```

---

## Testing

### Functional Testing
Conducted using:
- Flutter Testing Tools
- BrowserStack

### Test Areas

- User Authentication
- Dashboard Navigation
- Diet Planner Functionality
- Sleep Tracker Operations
- Period Tracker Logging
- Firestore Integration
- UI Responsiveness

---

## Future Enhancements

- AI-powered health recommendations
- Personalized diet generation
- Push notifications and reminders
- Email verification system
- Advanced cycle prediction
- Data analytics dashboard
- Google Sign-In integration
- Multi-language support
- Health report export

---

## Learning Outcomes

Through the development of CysterEase, the following skills were applied and strengthened:

- Flutter Application Development
- Firebase Integration
- Firestore Database Management
- UI/UX Design
- Mobile Application Architecture
- State Management
- Health Informatics Concepts
- Software Testing and Validation

---

## Author

Sri Pavatharani

Integrated M.Tech Computer Science and Engineering 

Project Title: CysterEase – A PCOS Wellness Companion

---

## License

This project was developed for educational and academic purposes.
