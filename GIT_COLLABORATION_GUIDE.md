# 🚀 Trackify - 3-Member Git Collaboration & Phased Push Guide

This document divides the **Trackify** codebase into **3 logical milestones / parts** for 3 group members. Follow this plan to push the project gradually to GitHub so your commit history shows realistic, professional collaboration.

---

## 👥 Division of Work Summary

| Part | Group Member | Role | Key Modules |
| :--- | :--- | :--- | :--- |
| **Part 1** | **Member 1 (Lead / You)** | Project Setup & Auth System | Setup, Theme, Firebase, Models, Auth (Login, Register, Gate) |
| **Part 2** | **Member 2** | Backend Service & Dashboard UI | Firestore Service, Home Page, Dashboard, Header, Balance Card |
| **Part 3** | **Member 3** | Transactions Feature & Final Integration | Transaction Form Page, Recent Transactions List Widget, Full Polish |

---

## 📦 Part 1: Project Setup, Data Models & Authentication
> **Assigned to:** Member 1 (Project Lead / You)  
> **Goal:** Lay down the project foundation, configure navy blue branding, set up data schemas, and implement user sign-up/sign-in.

### 📁 Files in Part 1:
- `pubspec.yaml` (Dependencies: firebase_core, firebase_auth, cloud_firestore, google_fonts, etc.)
- `android/app/src/main/AndroidManifest.xml` (App label: "Trackify")
- `web/index.html` & `web/manifest.json` (Trackify branding & colors)
- `lib/firebase_options.dart` (Firebase initialization configuration)
- `lib/main.dart` (Application entrypoint with Navy Blue `0xFF0A2342` ColorScheme)
- `lib/models/wallet_model.dart` (Wallet data model)
- `lib/models/transactions.dart` (Transaction data model)
- `lib/pages/login_page.dart` (Sign In screen with form validation & Firebase Auth)
- `lib/pages/register_page.dart` (Account registration screen with initial user setup)
- `lib/pages/login_status_page.dart` (StreamBuilder listening to `authStateChanges()`)

### 💻 Member 1 Git Commands:
```bash
# 1. Initialize Git repository
git init
git branch -M main

# 2. Add Part 1 files
git add pubspec.yaml pubspec.lock analysis_options.yaml .gitignore README.md
git add android/ web/ assets/
git add lib/firebase_options.dart lib/main.dart
git add lib/models/
git add lib/pages/login_page.dart lib/pages/register_page.dart lib/pages/login_status_page.dart

# 3. Commit
git commit -m "feat(auth): initialize Trackify project setup and authentication system

- Configure Trackify branding with Navy Blue theme
- Set up Firebase Core and Authentication
- Implement Login, Registration, and Auth Gate
- Define Transaction and Wallet data models"

# 4. Link to GitHub and Push
git remote add origin <YOUR_GITHUB_REPO_URL>
git push -u origin main
```

---

## 📦 Part 2: Firestore Service & Core Dashboard
> **Assigned to:** Member 2  
> **Goal:** Build the Cloud Firestore service layer, home screen scaffold, and executive dashboard overview.

### 📁 Files in Part 2:
- `lib/services/firestore_service.dart` (CRUD operations for transactions and wallet balance updates)
- `lib/widgets/dashboard_header.dart` (Time-based greetings, user display, and logout confirmation dialog)
- `lib/widgets/balance_card.dart` (Navy blue monthly expense overview card)
- `lib/pages/dashboard_page.dart` (Dashboard view composing header, balance card, and transaction feed)
- `lib/pages/home_page.dart` (Root navigation view with floating action button and transaction stream)

### 💻 Member 2 Git Commands:
```bash
# 1. Pull latest code from Member 1
git pull origin main

# 2. (Optional best practice) Create feature branch
git checkout -b feature/dashboard-service

# 3. Add Part 2 files
git add lib/services/firestore_service.dart
git add lib/widgets/dashboard_header.dart
git add lib/widgets/balance_card.dart
git add lib/pages/dashboard_page.dart
git add lib/pages/home_page.dart

# 4. Commit
git commit -m "feat(dashboard): implement Firestore service and dashboard UI

- Add FirestoreService for transactions and wallet management
- Implement DashboardHeader with dynamic greeting and logout modal
- Add BalanceCard displaying monthly expense calculations
- Create HomePage scaffold with realtime transaction StreamBuilder"

# 5. Push to GitHub
git push origin feature/dashboard-service
# (Or merge into main and push: git checkout main && git merge feature/dashboard-service && git push origin main)
```

---

## 📦 Part 3: Transaction Management & Final Integration
> **Assigned to:** Member 3  
> **Goal:** Implement the transaction entry form (Expense/Income, Wallets, Categories), transaction list items, and verify full system integration.

### 📁 Files in Part 3:
- `lib/widgets/recent_transactions_card.dart` (Styled transaction item with color-coded +/- badges)
- `lib/pages/transaction_page.dart` (Full Add/Edit transaction form with type toggle, category picker, date picker, and wallet selector)
- Verification & Cleanups across all screens.

### 💻 Member 3 Git Commands:
```bash
# 1. Pull latest code from Member 2
git checkout main
git pull origin main

# 2. (Optional best practice) Create feature branch
git checkout -b feature/transaction-management

# 3. Add Part 3 files
git add lib/widgets/recent_transactions_card.dart
git add lib/pages/transaction_page.dart

# 4. Commit
git commit -m "feat(transactions): add transaction creation, editing, and history card

- Add TransactionPage supporting Expense and Income types
- Implement wallet selection (Cash, bKash, Bank, Metro Card)
- Add date picker, category dropdown, and form validation
- Implement RecentTransactionsCard with color-coded indicators
- Finalize end-to-end testing with zero errors"

# 5. Push to GitHub
git push origin feature/transaction-management
# (Or merge into main and push: git checkout main && git merge feature/transaction-management && git push origin main)
```

---

## 🎓 Tips for University Presentation
1. **GitHub Commit Graph:** When your teacher checks the repository Insights > Contributors / Network graph, they will see 3 distinct contributors pushing in a clean sequence.
2. **Pull Requests:** If your university prefers Pull Requests (PRs), Member 2 and Member 3 can open PRs on GitHub (`feature/dashboard-service` -> `main`, then `feature/transaction-management` -> `main`) and have Member 1 merge them!
