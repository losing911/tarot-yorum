# Quickstart Guide

This guide provides instructions on how to set up the development environment and run the application.

## Prerequisites

*   Docker and Docker Compose
*   Node.js and npm (for frontend development)
*   A code editor (e.g., VS Code)

## Setup

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd <repository-name>
    ```

2.  **Set up environment variables**:
    *   Copy the `.env.example` files in the `frontend` and `backend` directories to `.env`.
    *   Fill in the required environment variables, such as database credentials and API keys.

3.  **Build and run the application**:
    ```bash
    docker-compose up --build
    ```
    This will start the frontend, backend, database, and other services.

## Running Tests

*   **To run all tests**:
    ```bash
    docker-compose exec backend npm test
    docker-compose exec frontend npm test
    ```

*   **To run backend tests**:
    ```bash
    docker-compose exec backend npm test
    ```

*   **To run frontend tests**:
    ```bash
    docker-compose exec frontend npm test
    ```

## Accessing the Application

*   **Frontend**: `http://localhost:3000`
*   **Backend API**: `http://localhost:4000`
*   **Admin Panel**: `http://localhost:3000/admin`
