# Overview
Athena is an application designed to efficiently manage university exams. Developed as a project for the Database course within the Bachelor's in Computer Science program at Ca' Foscari University, this system provides comprehensive tools for both instructors and students. It facilitates the creation, monitoring, and transparent management of the entire examination process.


# Key Features

### Exam Creation and Management
Instructors can create new exams, defining evaluation criteria, requirements, and relationships between different test components.

### Test Configuration
Detailed configuration tools for defining various test parameters, including type (written, oral, project), deadlines, and evaluation criteria.

### Registration for Tests
Students can register for tests within available examination sessions.

### Test Status Management
Monitoring of test status based on deadlines and subsequent attempts, validating the necessary tests required to pass an exam.

### Student Visibility and Monitoring
Clear overview of students' status, including tests taken, test history, and eligibility for exam registration based on completion of required tests.

### Intuitive Interface
User-friendly interface for seamless interaction by both instructors and students, ensuring efficient and effective management of university exams.


# System Requirements
Athena is designed for desktop browsers and may not be optimized for mobile devices.

# How to Use

Follow these steps to set up and run the project:

1.  Rename the example environment file:
    ```bash
    mv .env_example .env
    ```
    *(Edit the newly created `.env` file to configure database credentials and other settings as needed.)*

2.  Navigate into the frontend directory:
    ```bash
    cd frontend
    ```

3.  Clean the Flutter project dependencies and build artifacts:
    ```bash
    flutter clean
    ```

4.  Build the web version of the frontend application. This will generate the static files in `frontend/build/web`:
    ```bash
    flutter build web
    ```

5.  Go back to the project root directory:
    ```bash
    cd ..
    ```

6.  Start the Docker Compose services (backend, database, pgAdmin, and Nginx serving the frontend build):
    ```bash
    docker compose up
    ```
    *(Use `docker compose up --build` if you have made changes to the backend Dockerfile or need to rebuild images.)*

The services should now be running. You can typically access:
* Frontend: `http://localhost`
* Backend API: `http://localhost:8000`
* pgAdmin: `http://localhost:16543`

## Accounts

Here are some test accounts you can use to log in:

### Students

* **Roberto Neri:** `600653@unive.it` / `password123`
* **Luca Ottani:** `886512@unive.it` / `password456`
* **Francesca Francescani:** `787515@unive.it` / `password789`
* **Giulio Cesare:** `347315@unive.it` / `password987`

### Professors

* **Lucio Pozzobon:** `luciopozzobon@unive.it` / `password123`
* **Maria Bordin:** `mariabordin@unive.it` / `password456`
* **Francesco Quagliotto:** `francescoquagliotto@unive.it` / `password789`
* **Elena Rossi:** `elenarossi@unive.it` / `password321`

---