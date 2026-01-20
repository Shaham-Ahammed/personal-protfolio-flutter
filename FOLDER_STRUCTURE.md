# Portfolio Project Structure

This document explains the folder structure of your personal portfolio application.

## 📁 Folder Structure

```
lib/
├── main.dart                          # App entry point
├── constants/                         # Configuration and data files
│   ├── colors.dart                    # Color palette definitions
│   ├── text_styles.dart               # Responsive text style definitions
│   └── portfolio_data.dart            # Your personal information (customize here!)
├── models/                            # Data models
│   ├── project_model.dart             # Project data structure
│   ├── experience_model.dart          # Experience data structure
│   └── skill_model.dart               # Skill data structure
├── screens/                           # Screen widgets
│   └── portfolio_screen.dart          # Main portfolio screen with navigation
└── widgets/                           # Reusable UI components
    ├── navigation_bar.dart            # Top navigation bar (desktop & mobile)
    ├── home_section.dart              # Home section with profile & quote
    ├── skills_section.dart            # Skills showcase section
    ├── projects_section.dart          # Projects portfolio section
    ├── experience_section.dart        # Work experience timeline
    └── contact_section.dart           # Contact info & social links
```

## 🎨 Customization Guide

### 1. Update Your Personal Information
**File:** `lib/constants/portfolio_data.dart`

This is where you customize all your personal information:
- Name, title, bio, quote
- Profile picture URL
- Contact information (email, phone, location)
- Social media links (GitHub, LinkedIn, Twitter, Instagram)
- Skills with proficiency levels
- Projects with descriptions and links
- Work experience details

### 2. Change Colors
**File:** `lib/constants/colors.dart`

Modify the `AppColors` class to change the color scheme:
- Primary colors
- Background colors
- Text colors
- Accent colors
- Gradients

### 3. Adjust Text Styles
**File:** `lib/constants/text_styles.dart`

Customize font sizes, weights, and spacing for:
- Headings (H1, H2, H3, H4)
- Body text (large, medium, small)
- Special styles (quote, section titles, buttons)

### 4. Modify Sections
Each section is in its own widget file:
- `widgets/home_section.dart` - Home page layout
- `widgets/skills_section.dart` - Skills grid layout
- `widgets/projects_section.dart` - Projects card layout
- `widgets/experience_section.dart` - Experience timeline layout
- `widgets/contact_section.dart` - Contact cards and social links

### 5. Navigation
**File:** `widgets/navigation_bar.dart`

Customize the navigation bar:
- Menu items
- Active state styling
- Mobile menu layout

### 6. Main Screen Layout
**File:** `screens/portfolio_screen.dart`

Adjust the overall layout:
- Section order
- Scroll behavior
- Section height constraints

## 🚀 Running the App

### Web Development
```bash
flutter run -d chrome
```

### Build for Web
```bash
flutter build web
```

## 📱 Responsive Breakpoints

The app is responsive with the following breakpoints:
- **Mobile:** < 768px width
- **Desktop:** >= 768px width

Layouts automatically adjust based on screen size.

## 🎯 Key Features

✅ Fully responsive design
✅ Smooth scrolling navigation
✅ Section-based layout
✅ Social media integration
✅ Project showcase with links
✅ Experience timeline
✅ Skills with progress bars
✅ Modern, aesthetic UI
✅ Easy to customize

## 📝 Notes

- Replace placeholder image URLs with your actual profile picture
- Update all personal information in `portfolio_data.dart`
- Social media links will only appear if URLs are provided
- Project images use placeholder URLs - replace with your project screenshots
- All sections are easily customizable by editing their respective widget files

