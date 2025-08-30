-- Import data into Departments table
COPY departments(department_id, department_name, head_of_department_id)
FROM 'D:/tables/departments.csv'
DELIMITER ','
CSV HEADER;

-- Import data into Doctors table
COPY doctors(doctor_id, nic, name, date_of_birth, gender, phone_number, email, address,
             year_experience, specialization, department_id, salary, joining_date, is_active)
FROM 'D:/tables/doctors.csv'
DELIMITER ','
CSV HEADER;

-- Import data into Patients table
COPY patients(patient_id, first_name, last_name, date_of_birth, gender, phone_number, 
              blood_group, emergency_contact, address, registered_date, is_active)
FROM 'D:/tables/patients.csv'
DELIMITER ','
CSV HEADER;

-- Import data into Appointments table
COPY appointments(appointment_id, patient_id, doctor_id, appointment_date, appointment_time, 
                  reason_for_visit, status)
FROM 'D:/tables/appointments.csv'
DELIMITER ','
CSV HEADER;

-- Import data into Treatments table
COPY treatments(treatment_id, treatment_name, appointment_id, description, cost, treatment_date)
FROM 'D:/tables/treatments.csv'
DELIMITER ','
CSV HEADER;

-- Import data into Visit Records table
COPY visit_records(visit_id, appointment_id, patient_id, doctor_id, symptoms, disease, 
                   diagnosis, visit_date, next_appointment_date)
FROM 'D:/tables/visitrecords.csv'
DELIMITER ','
CSV HEADER;

-- Import data into Billing table
COPY billing(billing_id, patient_id, treatment_id, amount, payment_status, bill_date, due_date)
FROM 'D:/tables/billing.csv'
DELIMITER ','
CSV HEADER;
