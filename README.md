# Smart Public Fire Hydrant Maintenance System

A comprehensive blockchain-based system for managing fire hydrant maintenance, inspection, and monitoring using Clarity smart contracts.

## System Overview

This system consists of five interconnected smart contracts that manage different aspects of fire hydrant maintenance:

### 1. Inspection Scheduling Contract (`inspection-scheduling.clar`)
- Coordinates annual hydrant testing and flow checks
- Manages inspection schedules and completion tracking
- Handles inspector assignments and certifications

### 2. Repair Prioritization Contract (`repair-prioritization.clar`)
- Manages urgent versus routine maintenance needs
- Prioritizes repairs based on severity and impact
- Tracks repair status and completion

### 3. Water Pressure Monitoring Contract (`water-pressure-monitoring.clar`)
- Ensures adequate fire suppression capability
- Records pressure readings and flow rates
- Alerts for pressure anomalies

### 4. Location Mapping Contract (`location-mapping.clar`)
- Maintains GPS coordinates and accessibility information
- Tracks hydrant locations and street addresses
- Manages accessibility status for emergency vehicles

### 5. Winter Preparation Contract (`winter-preparation.clar`)
- Manages hydrant winterization in cold climates
- Schedules freeze protection maintenance
- Tracks winter readiness status

## Key Features

- **Decentralized Management**: All hydrant data stored on blockchain
- **Priority-Based Maintenance**: Automated prioritization of repairs
- **Real-Time Monitoring**: Continuous pressure and flow monitoring
- **Seasonal Preparation**: Automated winter preparation scheduling
- **Inspection Tracking**: Complete audit trail of all inspections

## Data Types

- **Hydrant ID**: Unique identifier (uint)
- **Priority Levels**: Critical (1), High (2), Medium (3), Low (4)
- **Status Types**: Active, Inactive, Under Repair, Winterized
- **Pressure Readings**: PSI measurements (uint)

## Getting Started

1. Deploy contracts in order: location-mapping, inspection-scheduling, repair-prioritization, water-pressure-monitoring, winter-preparation
2. Initialize hydrant locations using location-mapping contract
3. Schedule initial inspections
4. Begin monitoring and maintenance operations

## Testing

Run the test suite with:
\`\`\`
npm test
\`\`\`

Tests cover all contract functions and edge cases using Vitest framework.
