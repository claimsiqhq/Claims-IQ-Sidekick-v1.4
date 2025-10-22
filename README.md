# Claims IQ Sidekick v1.4

AI-powered field inspection and claims management app for insurance adjusters.

## Overview

Claims IQ Sidekick is a comprehensive iOS application designed to streamline the daily operations of field adjusters in the claims processing and inspection business. The app leverages AI technology (OpenAI Vision and GPT) to automate document processing, generate inspection workflows, annotate photos, and provide intelligent daily insights.

## Key Features

### 1. My Day Dashboard
- **AI-Powered Insights**: Daily briefing with priorities, routing suggestions, and actionable recommendations
- **Weather Integration**: Real-time weather conditions and forecasts for field work planning
- **Route Planning**: ETA calculations and directions to claim sites
- **Calendar Integration**: Quick access to O365 calendar for appointment management

### 2. Claims Management
- **FNOL Processing**: Upload and parse First Notice of Loss PDFs using OpenAI Vision
- **Automatic Data Extraction**: AI extracts key information (dates, addresses, damage details, etc.)
- **Claim Tracking**: Organize and filter claims by status (Active, Pending, Completed)
- **Document Storage**: Secure local storage of all claim documents

### 3. AI-Generated Inspection Workflows
- **Custom Workflows**: AI generates tailored inspection checklists based on FNOL data
- **Step-by-Step Guidance**: Organized inspection tasks specific to damage type
- **Progress Tracking**: Visual progress indicators and completion tracking
- **Dynamic Updates**: Workflows adapt to claim specifics

### 4. Intelligent Photo Capture
- **AI Photo Annotation**: Automatic damage detection and annotation using OpenAI Vision
- **Location Tagging**: GPS coordinates embedded in photo metadata
- **High-Quality Capture**: Configurable photo quality settings
- **Offline Support**: Queue photos for upload when connection is available

### 5. LiDAR 3D Scanning
- **3D Property Mapping**: Capture detailed 3D scans of affected areas using LiDAR
- **Measurement Accuracy**: Precise spatial measurements for damage assessment
- **Multiple Scan Types**: Support for room-level, exterior, and full property scans
- **Local Storage**: Secure storage of scan data with claim association

### 6. Offline-First Architecture
- **Work Anywhere**: Full functionality without internet connection
- **Smart Sync**: Automatic background synchronization when online
- **Queue Management**: Intelligent operation queuing for offline work
- **Conflict Resolution**: Seamless data merging when connectivity resumes

## Technology Stack

- **Framework**: SwiftUI
- **Data Persistence**: SwiftData
- **AI Integration**: OpenAI GPT-4o and Vision API
- **Location Services**: CoreLocation
- **AR/LiDAR**: ARKit and RealityKit
- **Weather**: WeatherKit
- **Calendar**: EventKit
- **Network Monitoring**: Network framework

## Architecture

### Data Models
- **Claim**: Core claim entity with relationships to all supporting data
- **FNOL**: First Notice of Loss with AI-extracted fields
- **InspectionWorkflow**: AI-generated inspection steps and items
- **Photo**: Image captures with AI annotations and metadata
- **LiDARScan**: 3D scan data and metadata
- **DailyInsight**: AI-generated daily briefings

### Services
- **OpenAIService**: Handles all AI processing (FNOL parsing, workflow generation, photo annotation, insights)
- **LocationService**: GPS tracking and route calculations
- **StorageService**: File management for photos, PDFs, and LiDAR data
- **WeatherService**: Weather data integration
- **CalendarService**: O365 calendar integration
- **NetworkMonitor**: Connection status monitoring
- **SyncManager**: Offline operation queue and synchronization

### ViewModels
- **MyDayViewModel**: Daily dashboard logic
- **ClaimsViewModel**: Claims list and FNOL processing
- **InspectionViewModel**: Photo capture and LiDAR scanning
- **SettingsViewModel**: App configuration and storage management

## Design System

### Brand Colors
- **Primary**: #7763B7 (Purple)
- **Secondary**: #9D8BBF (Light Purple)
- **Tertiary**: #CDBFF7 (Lightest Purple)
- **Accent Primary**: #C6A54E (Gold)
- **Accent Secondary**: #EAD4A2 (Light Gold)
- **Dark**: #342A4F (Navy)
- **Neutrals**: Various shades for backgrounds and borders

### UI Components
- Custom gradient buttons using brand colors
- Rounded card-based layouts
- Consistent spacing and typography
- SF Symbols for icons
- Purple/gold accent scheme throughout

## Setup Instructions

### Prerequisites
1. Xcode 15.0 or later
2. iOS 17.0 or later deployment target
3. OpenAI API key

### Configuration

1. **OpenAI API Key**
   - Launch the app
   - Navigate to Settings tab
   - Tap on "OpenAI API Key"
   - Enter your API key (starts with `sk-`)
   - The key is stored securely in UserDefaults

2. **Permissions**
   - Grant camera access for photo capture
   - Grant location access for GPS tagging
   - Grant calendar access for appointment management
   - All permissions can be managed in iOS Settings

3. **Directory Structure**
   The app creates the following directories in Documents:
   - `/Photos` - Inspection photos
   - `/FNOLs` - PDF documents
   - `/LiDAR` - 3D scan data

## Usage Guide

### Processing a FNOL
1. Navigate to Claims tab
2. Tap the "+" button
3. Select "Upload FNOL"
4. Choose a PDF file from your device
5. AI will automatically extract and analyze the contents
6. Review extracted data
7. Generate an inspection workflow

### Conducting an Inspection
1. Navigate to Inspection tab
2. Select an active claim
3. Enable location tracking
4. Capture photos (AI will auto-annotate)
5. Perform LiDAR scans for affected areas
6. Follow the AI-generated checklist
7. All data syncs automatically when online

### Reviewing Daily Insights
1. Navigate to My Day tab
2. Tap refresh on the Insights card
3. AI analyzes your active claims, location, and weather
4. Review priorities and routing suggestions
5. Access O365 calendar for scheduling

## Offline Capabilities

The app is designed to work seamlessly offline:

- **Capture Data**: Take photos, perform scans, add notes
- **Queue Operations**: All uploads queued automatically
- **Background Sync**: Automatic sync when connection detected
- **Sync Status**: Visual indicator shows pending operations
- **Manual Sync**: Force sync from Settings tab

## Storage Management

Monitor and manage storage from Settings:

- **Photos**: View total storage used by inspection photos
- **FNOL Documents**: Track PDF storage usage
- **LiDAR Scans**: Monitor 3D scan data size
- **Clear Cache**: Remove temporary files
- **Delete Offline Data**: Clear queued operations (use with caution)

## Security & Privacy

- **Local Storage**: All data stored locally on device
- **API Key Security**: OpenAI key stored in encrypted UserDefaults
- **No Cloud Storage**: Data remains on device (sync feature for future)
- **Permission-Based**: All sensitive features require user permission

## Future Enhancements

Potential features for future versions:
- Cloud backup and sync across devices
- Team collaboration features
- Export reports in multiple formats
- Voice note transcription
- Integration with claim management systems
- Advanced analytics and reporting
- Push notifications for claim updates
- Multi-language support

## Troubleshooting

### Common Issues

**Photos not saving**
- Check camera permissions in iOS Settings
- Verify sufficient storage space
- Ensure app has photo library access

**AI features not working**
- Verify OpenAI API key is configured
- Check internet connection for first-time processing
- Review API key permissions and credits

**Location not tracking**
- Enable location services in iOS Settings
- Grant "Always" permission for background tracking
- Check location accuracy settings

**Sync not working**
- Verify internet connection
- Check sync status in Settings
- Try manual sync from Settings tab

## Support

For issues, questions, or feature requests, contact support at john.shoust@pm.me

## Version History

### v1.4 (Current)
- Initial release with core features
- AI-powered FNOL processing
- Photo annotation with OpenAI Vision
- LiDAR scanning support
- Offline-first architecture
- Daily AI insights
- Full navigation and UI implementation

## License

© 2025 Claims IQ. All rights reserved.

