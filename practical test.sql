
# -- HOSPITAL MANAGEMENT SYSTEM - COMPLETE SQL SOLUTION--

-- 1. CREATE DATABASE & SCHEMA

CREATE DATABASE hospital_management;
USE hospital_management;

-- Table 1: Patients
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender ENUM('M', 'F', 'O'),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    registration_date DATE
);

-- Table 2: Departments
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table 3: Doctors
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    available_days VARCHAR(50),
    consultation_fee DECIMAL(8,2),
    years_experience INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Table 4: Doctor_Department (Mapping)
CREATE TABLE Doctor_Department (
    doctor_id INT,
    department_id INT,
    PRIMARY KEY (doctor_id, department_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Table 5: Appointments
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Table 6: Medical_Records
CREATE TABLE Medical_Records (
    record_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    diagnosis TEXT,
    prescription TEXT,
    treatment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Table 7: Billing
CREATE TABLE Billing (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    appointment_id INT,
    amount DECIMAL(8,2),
    payment_status ENUM('Paid', 'Pending', 'Cancelled') DEFAULT 'Pending',
    payment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);


-- 2. SAMPLE DATA INSERT (CRUD - Task 1)

INSERT INTO Departments (department_name) VALUES 
('Cardiology'), ('Neurology'), ('Orthopedics'), ('Dermatology'), ('General');

INSERT INTO Doctors (name, specialization, phone_number, email, available_days, consultation_fee, years_experience, department_id) VALUES 
('Dr. Raj Patel', 'Cardiologist', '9876543210', 'raj@hospital.com', 'Mon,Wed,Fri', 1500.00, 20, 1),
('Dr. Priya Sharma', 'Neurologist', '9876543211', 'priya@hospital.com', 'Tue,Thu', 1200.00, 12, 2),
('Dr. Amit Desai', 'Orthopedist', '9876543212', 'amit@hospital.com', 'Mon,Wed,Sat', 1800.00, 8, 3),
('Dr. Neha Gupta', 'Dermatologist', '9876543213', 'neha@hospital.com', 'Thu,Fri', 800.00, 5, 4),
('Dr. Vikram Singh', 'General Physician', '9876543214', 'vikram@hospital.com', 'Daily', 500.00, 3, 5);

INSERT INTO Patients (name, dob, gender, phone_number, email, address, registration_date) VALUES 
('Amit Shah', '1985-05-15', 'M', '9123456789', 'amit@email.com', 'Ahmedabad, Gujarat', '2025-01-01'),
('Priyanka Jain', '1990-08-22', 'F', '9123456790', 'priyanka@email.com', 'Surat, Gujarat', '2025-01-02'),
('Rahul Mehta', '1995-03-10', 'M', '9123456791', 'rahul@email.com', 'Vadodara, Gujarat', '2025-01-03'),
('Sneha Patel', '1988-11-30', 'F', '9123456792', 'sneha@email.com', 'Rajkot, Gujarat', '2025-01-04'),
('Karan Desai', '2000-07-12', 'M', '9123456793', 'karan@email.com', 'Ahmedabad, Gujarat', '2025-01-05');

INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status) VALUES 
(1, 1, '2025-01-10 10:00:00', 'Completed'),
(2, 2, '2025-01-11 11:00:00', 'Scheduled'),
(3, 3, '2025-01-12 14:00:00', 'Completed'),
(4, 4, '2025-01-13 15:00:00', 'Cancelled'),
(1, 5, '2025-01-14 09:00:00', 'Scheduled');

INSERT INTO Medical_Records (patient_id, doctor_id, diagnosis, prescription) VALUES 
(1, 1, 'Hypertension', 'Amlodipine 5mg daily'),
(3, 3, 'Fracture', 'Cast for 6 weeks'),
(1, 5, 'Fever', 'Paracetamol 500mg');

INSERT INTO Billing (patient_id, appointment_id, amount, payment_status, payment_date) VALUES 
(1, 1, 1500.00, 'Paid', '2025-01-10'),
(3, 3, 1800.00, 'Paid', '2025-01-12'),
(2, 2, 1200.00, 'Pending', NULL);


-- 3. TASKS SOLUTIONS (Sequence Wise)


-- TASK 1: CRUD Operations (Already done above)

-- TASK 2: SQL Clauses (WHERE, HAVING, LIMIT)
SELECT * FROM Patients WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) ORDER BY registration_date DESC;
SELECT patient_id, SUM(amount) as total_spent FROM Billing GROUP BY patient_id HAVING total_spent > 1000 ORDER BY total_spent DESC LIMIT 5;
SELECT * FROM Doctors WHERE consultation_fee > 1000;

-- TASK 3: SQL Operators (AND, OR, NOT)
SELECT * FROM Appointments WHERE status = 'Scheduled' AND doctor_id = 1;
SELECT * FROM Doctors WHERE specialization IN ('Cardiology', 'Neurology');
SELECT * FROM Patients WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM Appointments WHERE YEAR(appointment_date) = YEAR(CURDATE()));

-- TASK 4: Sorting & Grouping (ORDER BY, GROUP BY)
SELECT * FROM Doctors ORDER BY specialization, name;
SELECT d.name, COUNT(a.appointment_id) as patient_count FROM Doctors d LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id GROUP BY d.doctor_id, d.name;
SELECT dep.department_name, COALESCE(SUM(b.amount), 0) as total_revenue FROM Departments dep LEFT JOIN Doctor_Department dd ON dep.department_id = dd.department_id LEFT JOIN Doctors d ON dd.doctor_id = d.doctor_id LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id LEFT JOIN Billing b ON a.appointment_id = b.appointment_id GROUP BY dep.department_id, dep.department_name ORDER BY total_revenue DESC;

-- TASK 5: Aggregate Functions (SUM, AVG, MAX, MIN, COUNT)
SELECT SUM(amount) as total_revenue FROM Billing WHERE payment_status = 'Paid';
SELECT d.name, COUNT(a.appointment_id) as visit_count FROM Doctors d LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id GROUP BY d.doctor_id, d.name ORDER BY visit_count DESC LIMIT 1;
SELECT AVG(consultation_fee) as avg_fee FROM Doctors;

-- TASK 6: Primary & Foreign Key Relationships (Schema already defines them)

-- TASK 7: Joins (INNER, LEFT, RIGHT, FULL OUTER equivalent)
-- INNER JOIN
SELECT d.name as doctor_name, dep.department_name FROM Doctors d INNER JOIN Doctor_Department dd ON d.doctor_id = dd.doctor_id INNER JOIN Departments dep ON dd.department_id = dep.department_id;

-- LEFT JOIN
SELECT p.name, a.appointment_date FROM Patients p LEFT JOIN Appointments a ON p.patient_id = a.patient_id WHERE a.status = 'Completed';

-- RIGHT JOIN (Appointments RIGHT JOIN Doctors)
SELECT a.appointment_id, d.name FROM Appointments a RIGHT JOIN Doctors d ON a.doctor_id = d.doctor_id;

-- FULL OUTER JOIN equivalent (UNION)
SELECT p.patient_id, p.name, NULL as appointment_id FROM Patients p 
LEFT JOIN Appointments a ON p.patient_id = a.patient_id WHERE a.appointment_id IS NULL
UNION
SELECT NULL, NULL, a.appointment_id FROM Appointments a 
LEFT JOIN Patients p ON a.patient_id = p.patient_id WHERE p.patient_id IS NULL;

-- TASK 8: Subqueries
SELECT * FROM Doctors WHERE doctor_id IN (SELECT doctor_id FROM Appointments GROUP BY doctor_id HAVING COUNT(*) > 2);
SELECT p.name, SUM(b.amount) as total_spent FROM Patients p JOIN Billing b ON p.patient_id = b.patient_id GROUP BY p.patient_id, p.name ORDER BY total_spent DESC LIMIT 1;
SELECT a.* FROM Appointments a WHERE a.doctor_id IN (SELECT doctor_id FROM Doctors WHERE specialization = 'Dermatology');

-- TASK 9: Date & Time Functions
SELECT MONTH(appointment_date) as month, COUNT(*) as appointments FROM Appointments GROUP BY MONTH(appointment_date);
SELECT DATEDIFF('2025-01-20', appointment_date) as days_since_appointment FROM Appointments;
SELECT DATE_FORMAT(treatment_date, '%d-%m-%Y') as formatted_date FROM Medical_Records;

-- TASK 10: String Manipulation Functions
SELECT UPPER(name) as patient_name FROM Patients;
SELECT TRIM(phone_number) FROM Doctors WHERE phone_number LIKE '% %';
SELECT CASE WHEN phone_number IS NULL OR phone_number = '' THEN 'Not Available' ELSE phone_number END as clean_phone FROM Patients;

-- TASK 11: Window Functions
-- Rank doctors by patient count
SELECT name, COUNT(appointment_id) as patient_count,
       RANK() OVER (ORDER BY COUNT(appointment_id) DESC) as patient_rank
FROM Doctors d LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id 
GROUP BY d.doctor_id, d.name;

-- Cumulative revenue per month
SELECT YEAR(appointment_date) as year, MONTH(appointment_date) as month,
       SUM(amount) as monthly_revenue,
       SUM(amount) OVER (ORDER BY YEAR(appointment_date), MONTH(appointment_date)) as cumulative_revenue
FROM Appointments a JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY YEAR(appointment_date), MONTH(appointment_date);

-- Running total of appointments
SELECT appointment_date, COUNT(*) as daily_count,
       SUM(COUNT(*)) OVER (ORDER BY appointment_date) as running_total
FROM Appointments GROUP BY appointment_date ORDER BY appointment_date;

-- TASK 12: CASE Expressions (Patient Risk & Doctor Level)
-- Patient Risk Level
SELECT p.patient_id, p.name,
       CASE 
           WHEN COUNT(m.record_id) > 5 THEN 'High'
           WHEN COUNT(m.record_id) BETWEEN 3 AND 5 THEN 'Medium'
           ELSE 'Low'
       END as risk_level
FROM Patients p LEFT JOIN Medical_Records m ON p.patient_id = m.patient_id
GROUP BY p.patient_id, p.name;

-- Doctor Experience Level
SELECT d.doctor_id, d.name,
       CASE 
           WHEN years_experience > 15 THEN 'Senior'
           WHEN years_experience BETWEEN 5 AND 15 THEN 'Mid-Level'
           ELSE 'Junior'
       END as experience_level
FROM Doctors d;


-- UPDATE OPERATIONS (Task 1 continued)

UPDATE Patients SET address = 'New Address, Ahmedabad' WHERE patient_id = 1;
DELETE FROM Appointments WHERE status = 'Cancelled' AND appointment_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);


-- ANALYSIS QUERIES (Bonus Performance Analysis)

-- Total Revenue
SELECT SUM(amount) as total_revenue FROM Billing WHERE payment_status = 'Paid';

-- Most Visited Department
SELECT dep.department_name, COUNT(a.appointment_id) as visit_count
FROM Departments dep JOIN Doctor_Department dd ON dep.department_id = dd.department_id
JOIN Doctors d ON dd.doctor_id = d.doctor_id LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY dep.department_id, dep.department_name ORDER BY visit_count DESC LIMIT 1;

