-- 1. List all patients who have more than 3 appointments scheduled.
SELECT
    p.patient_id, COUNT(*) AS sc_count, p.first_name, p.last_name, p.gender
FROM
    patients p
    JOIN appointments a ON p.patient_id = a.patient_id
WHERE
    status = 'Scheduled'
GROUP BY
    p.patient_id, p.first_name, p.last_name, p.gender
HAVING
    COUNT(*) > 3;

-- 2. Find the top 5 doctors who handled the most appointments.
SELECT
    a.doctor_id, d.name, COUNT(a.doctor_id) AS Number_of_handle
FROM
    appointments a 
    JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY
    a.doctor_id, d.name
ORDER BY
    COUNT(a.doctor_id) DESC
LIMIT 5;

-- 3. Show the number of appointments by status (Scheduled, Completed, Cancelled).
SELECT
    status, COUNT(status) AS number_of_appointments
FROM
    appointments
GROUP BY
    status;

-- 4. Find patients who never showed up for any of their appointments.
SELECT
    p.patient_id, p.first_name, p.last_name, p.gender, p.phone_number
FROM
    patients p
    LEFT JOIN appointments a ON p.patient_id = a.patient_id AND a.status IN ('Scheduled', 'Completed')
WHERE
    a.appointment_id IS NULL;

-- 5. Retrieve the details of appointments scheduled in the next 7 days.
SELECT
    *
FROM
    appointments
WHERE
    appointment_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days';

-- 6. Find the department with the highest number of doctors.
SELECT
    d.department_id, d.department_name, COUNT(de.doctor_id) AS number_of_doctor
FROM
    doctors de
    JOIN departments d ON d.department_id = de.department_id
GROUP BY
    d.department_id, d.department_name
ORDER BY
    COUNT(de.doctor_id) DESC
LIMIT 1;

-- 7. Calculate the average billing amount per patient.
SELECT
    p.patient_id, p.first_name, p.last_name, p.gender, AVG(b.amount)
FROM
    patients p
    JOIN billing b ON p.patient_id = b.patient_id
GROUP BY
    p.patient_id, p.first_name, p.last_name, p.gender;

-- 8. List patients who spent more than 10,000 in total treatment costs.
SELECT
    p.patient_id, p.first_name, p.last_name, p.gender, SUM(t.cost)
FROM
    patients p
    JOIN appointments a ON p.patient_id = a.patient_id
    JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY
    p.patient_id, p.first_name, p.last_name, p.gender
HAVING
    SUM(t.cost) > 10000;

-- 9. Show the doctor who generated the highest total revenue.
SELECT
    d.doctor_id, d.name, SUM(b.amount) AS total_revenue
FROM
    billing b
    JOIN treatments t ON b.treatment_id = t.treatment_id
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY
    d.doctor_id, d.name
ORDER BY
    SUM(b.amount) DESC
LIMIT 1;

-- 10. Get the number of unique patients treated by each department.
SELECT
    de.department_name, COUNT(DISTINCT a.patient_id)
FROM
    appointments a
    JOIN doctors d ON a.doctor_id = d.doctor_id
    JOIN departments de ON de.department_id = d.department_id
GROUP BY
    de.department_name;

-- 11. Find the month with the highest number of new patient registrations.
SELECT
    EXTRACT(MONTH FROM registered_date) AS months, EXTRACT(YEAR FROM registered_date) AS years, COUNT(patient_id)
FROM
    patients
GROUP BY
    months, years
ORDER BY
    COUNT(patient_id) DESC
LIMIT 1;

-- 12. Retrieve patients who have appointments with more than one doctor.
SELECT
    p.patient_id, p.first_name, p.last_name, p.gender, COUNT(DISTINCT a.doctor_id) AS num_doc
FROM
    patients p 
    JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id, p.first_name, p.last_name, p.gender
HAVING
    COUNT(DISTINCT a.doctor_id) > 1;

-- 13. Show doctors who have appointments in more than one department.
SELECT
    d.doctor_id, d.name, d.gender, d.phone_number, COUNT(DISTINCT doc.department_id) AS num_departments
FROM
    appointments a
    JOIN doctors d ON a.doctor_id = d.doctor_id
    JOIN departments doc ON d.department_id = doc.department_id
GROUP BY
    d.doctor_id, d.name, d.gender, d.phone_number
HAVING
    COUNT(DISTINCT doc.department_id) > 1;

-- 14. Find the most common diagnosis (treatment reason) across all patients.
SELECT
    diagnosis, COUNT(diagnosis)
FROM
    visit_records
GROUP BY
    diagnosis
ORDER BY
    COUNT(diagnosis) DESC;

-- 15. List patients who had consecutive missed appointments (No-show).
SELECT
    patient_id, appointment_id, appointment_date, status
FROM
    (
        SELECT
            patient_id, appointment_id, appointment_date, status,
            LAG(status) OVER (PARTITION BY patient_id ORDER BY appointment_date) AS prev_status
        FROM
            appointments
    ) sub
WHERE
    status = 'No-show' AND prev_status = 'No-show'
ORDER BY
    patient_id, appointment_date;

-- 16. Get the average length of treatment (difference between first and last visit) per patient.
SELECT
    DISTINCT p.patient_id, p.first_name, p.last_name, p.registered_date,
    MAX(a.appointment_date) AS last_visit, AGE(MAX(a.appointment_date), p.registered_date)
FROM
    patients p
    LEFT JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id, p.first_name, p.last_name, p.registered_date;

-- 17. Show the top 3 most expensive treatments and the patients who received them.
SELECT
    t.treatment_name, p.first_name, p.last_name, t.cost
FROM
    treatments t
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN patients p ON p.patient_id = a.patient_id
ORDER BY
    cost DESC
LIMIT 3;

-- 18. Find all appointments where patient and doctor belong to the same city.
-- Note: Query requires city extraction from address fields

-- 19. Retrieve doctors who don’t have any appointments yet.
SELECT
    d.doctor_id, d.name, d.gender, d.phone_number
FROM
    doctors d
    LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
WHERE
    a.appointment_id IS NULL;

-- 20. Get the trend of appointments over time (group by month and year).
SELECT
    COUNT(DISTINCT appointment_id) AS number_of_appointment,
    EXTRACT(MONTH FROM appointment_date) AS months,
    EXTRACT(YEAR FROM appointment_date) AS years
FROM
    appointments
GROUP BY
    months, years
ORDER BY
    months;

-- 21. List all patients along with their assigned doctors and upcoming appointment dates.
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name, p.gender,
    d.name AS doctor_name, MAX(a.appointment_date) AS upcoming_appointment
FROM
    patients p
    JOIN appointments a ON p.patient_id = a.patient_id
    JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY
    patient_name, p.gender, doctor_name;

-- 22. Find the top 5 doctors with the highest number of completed appointments.
SELECT
    a.doctor_id, d.name, COUNT(*) FILTER(WHERE a.status = 'Completed') AS comp
FROM
    appointments a
    JOIN doctors d ON d.doctor_id = a.doctor_id
GROUP BY
    a.doctor_id, d.name
ORDER BY
    comp DESC
LIMIT 5;

-- 23. Retrieve the total revenue generated from treatments in each department.
SELECT
    dep.department_name, SUM(t.cost) AS total_revenue
FROM
    treatments t
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN doctors d ON a.doctor_id = d.doctor_id
    JOIN departments dep ON dep.department_id = d.department_id
GROUP BY
    dep.department_name;

-- 24. Show all patients who had more than 3 visits in the last 6 months.
SELECT
    p.patient_id, p.first_name, p.last_name, p.gender, COUNT(v.visit_id) AS no_of_visit
FROM
    patients p
    JOIN visit_records v ON p.patient_id = v.patient_id
WHERE
    visit_date BETWEEN CURRENT_DATE - INTERVAL '6 months' AND CURRENT_DATE
GROUP BY
    p.patient_id, p.first_name, p.last_name, p.gender
HAVING
    COUNT(v.visit_id) > 3
ORDER BY
    no_of_visit DESC;

-- 25. Find the average treatment cost per department.
SELECT
    dep.department_name, AVG(t.cost) AS average_treatment_cost
FROM
    treatments t
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN doctors d ON d.doctor_id = a.doctor_id
    JOIN departments dep ON dep.department_id = d.department_id
GROUP BY
    dep.department_name;

-- 26. Get the list of patients who never missed an appointment (no 'No-show').
SELECT
    p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, p.gender
FROM
    patients p
WHERE
    NOT EXISTS(
        SELECT 1 FROM appointments a WHERE p.patient_id = a.patient_id AND a.status = 'No-show'
    );

-- 27. Retrieve doctors who are specialized in more than one department (if applicable).
SELECT
    d.doctor_id, d.name, COUNT(DISTINCT d.specialization) AS no_of_specialization
FROM
    doctors d
    JOIN departments dep ON d.department_id = dep.department_id
GROUP BY
    d.doctor_id, d.name
HAVING
    COUNT(DISTINCT d.specialization) > 1;

-- 28. List patients along with their last treatment date and treatment type.
SELECT
    patient_id, patient_name, gender, treatment_name
FROM
    (
        SELECT
            p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, p.gender,
            t.treatment_date, t.treatment_name,
            ROW_NUMBER() OVER(PARTITION BY p.patient_id ORDER BY t.treatment_id DESC) AS rn
        FROM
            patients p
            JOIN appointments a ON p.patient_id = a.patient_id
            JOIN treatments t ON t.appointment_id = a.appointment_id
    ) sub
WHERE
    rn = 1;

-- 29. Show the trend of appointments per month in 2025.
SELECT
    EXTRACT(MONTH FROM appointment_date) AS months, EXTRACT(YEAR FROM appointment_date) AS years,
    COUNT(appointment_id) AS number_of_appointments
FROM
    appointments
WHERE
    EXTRACT(YEAR FROM appointment_date) = 2025
GROUP BY
    months, years;

-- 30. Find the patient who spent the maximum amount on treatments.
SELECT
    p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, p.gender, SUM(t.cost) AS total_amount
FROM
    treatments t
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN patients p ON a.patient_id = p.patient_id
GROUP BY
    p.patient_id, patient_name, p.gender
ORDER BY
    SUM(t.cost) DESC
LIMIT 1;

-- 31. Retrieve the doctor with the highest number of unique patients treated.
SELECT
    a.doctor_id, d.name, COUNT(DISTINCT a.patient_id) AS number_of_treat
FROM
    appointments a 
    JOIN doctors d ON d.doctor_id = a.doctor_id
WHERE
    a.status = 'Completed'
GROUP BY
    a.doctor_id, d.name
HAVING
    COUNT(DISTINCT a.patient_id) > 0
ORDER BY
    number_of_treat DESC LIMIT 1;

-- 32. List all bills where the payment status is 'Pending' and appointment date is past due.
SELECT
    billing_id
FROM
    billing
WHERE
    payment_status = 'Pending' AND due_date < CURRENT_DATE;

-- 33. Get the ratio of 'No-show' vs 'Completed' appointments per department.
SELECT
    dep.department_name,
    COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) AS completed,
    COUNT(CASE WHEN a.status = 'No-show' THEN 1 END) AS no_show,
    SUM(COUNT(*)) OVER() AS total_appointment,
    CONCAT(ROUND((COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) / SUM(COUNT(*)) OVER()) * 100, 2), '%') AS completed_ratio,
    CONCAT(ROUND((COUNT(CASE WHEN a.status = 'No-show' THEN 1 END) / SUM(COUNT(*)) OVER()) * 100, 2), '%') AS no_show_ratio
FROM
    appointments a
    JOIN doctors d ON d.doctor_id = a.doctor_id
    JOIN departments dep ON d.department_id = dep.department_id
GROUP BY
    dep.department_name;

-- 34. Find which treatment type is most common among patients above 50 years old.
-- Note: Age data not available in the database

-- 35. Show patient name, treatment name and total cost for patients who took more than one treatment.
SELECT
    patient_id, patient_name, treatment_name, total_cost
FROM
    (
        SELECT
            p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, t.treatment_name, t.cost,
            COUNT(t.treatment_id) OVER (PARTITION BY p.patient_id) AS rn,
            SUM(t.cost) OVER (PARTITION BY p.patient_id) AS total_cost
        FROM
            treatments t
            JOIN appointments a ON t.appointment_id = a.appointment_id
            JOIN patients p ON p.patient_id = a.patient_id
    ) sub
WHERE
    rn > 1;

-- 36. Generate a report of total appointments, completed appointments, and no-shows by doctor.
SELECT
    d.doctor_id, d.name,
    COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) AS complete_appointment,
    COUNT(CASE WHEN a.status = 'No-show' THEN 1 END) AS no_show_appointment
FROM
    appointments a
    JOIN doctors d ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id, d.name;

-- 37. Find all patients who had chemotherapy as treatment and their assigned doctor.
SELECT
    t.treatment_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    t.treatment_name, d.doctor_id, d.name AS doctor_name
FROM
    treatments t
    JOIN appointments a ON t.appointment_id = a.appointment_id
    JOIN patients p ON p.patient_id = a.patient_id
    JOIN doctors d ON d.doctor_id = a.doctor_id
WHERE
    t.treatment_name = 'Chemotherapy'
ORDER BY
    treatment_id;

-- 38. Retrieve the department with the highest number of appointments.
SELECT
    dep.department_name, COUNT(a.appointment_id) AS num_of_app
FROM
    appointments a
    JOIN doctors d ON d.doctor_id = a.doctor_id
    JOIN departments dep ON dep.department_id = d.department_id
GROUP BY
    dep.department_name
ORDER BY
    num_of_app DESC
LIMIT 1;

-- 39. Show the average time difference (in days) between appointment scheduling and actual appointment date.
-- Note: Scheduling date column not available in appointments table

-- 40. Get the list of doctors who never had a 'No-show' appointment.
SELECT
    doctor_id, name
FROM
    (
        SELECT
            d.doctor_id, d.name,
            COUNT(CASE WHEN a.status = 'No-show' THEN 1 END) AS no_show_appointment
        FROM
            appointments a
            JOIN doctors d ON d.doctor_id = a.doctor_id
        GROUP BY
            d.doctor_id, d.name
    ) sub
WHERE
    no_show_appointment = 0;    p.first_name,
    p.last_name,
    p.gender,
    p.phone_number
FROM
    patients p
    LEFT JOIN appointments a ON p.patient_id = a.patient_id
    AND a.status IN ('Scheduled', 'Completed')
WHERE
    a.appointment_id IS NULL;

-- 5. Retrieve the details of appointments scheduled in the next 7 days.
SELECT
    *
FROM
    appointments
WHERE
    appointment_date BETWEEN CURRENT_DATE
    AND CURRENT_DATE + INTERVAL '7 days';

-- 6. Find the department with the highest number of doctors.
SELECT
    d.department_id,
    d.department_name,
    COUNT(de.doctor_id) AS number_of_doctor
FROM
    doctors de
    JOIN departments d ON d.department_id = de.department_id
GROUP BY
    d.department_id,
    d.department_name
ORDER BY
    COUNT(de.doctor_id) DESC
LIMIT 1;

-- 7. Calculate the average billing amount per patient.
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    p.gender,
    AVG(b.amount)
FROM
    patients p
    JOIN billing b ON p.patient_id = b.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name,
    p.gender;

-- 8. List patients who spent more than 10,000 in total treatment costs.
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    p.gender,
    SUM(t.cost)
FROM
    patients p
    JOIN appointments a ON p.patient_id = a.patient_id
    JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name,
    p.gender
HAVING
    SUM(t.cost) > 10000;

-- 9. Show the doctor who generated the highest total revenue.
SELECT
    d.doctor_id,
    d.name,
    SUM(b.amount) AS total_revenue
FROM
    billing b
    JOIN treatments t ON b.treatment_id = t.treatment_id
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY
    d.doctor_id,
    d.name
ORDER BY
    SUM(b.amount) DESC
LIMIT 1;

-- 10. Get the number of unique patients treated by each department.
SELECT
    de.department_name,
    COUNT(DISTINCT a.patient_id)
FROM
    appointments a
    JOIN doctors d ON a.doctor_id = d.doctor_id
    JOIN departments de ON de.department_id = d.department_id
GROUP BY
    de.department_name;

-- 11. Find the month with the highest number of new patient registrations.
SELECT
    EXTRACT(MONTH FROM registered_date) AS months,
    EXTRACT(YEAR FROM registered_date) AS years,
    COUNT(patient_id)
FROM
    patients
GROUP BY
    months,
    years
ORDER BY
    COUNT(patient_id) DESC
LIMIT 1;

-- 12. Retrieve patients who have appointments with more than one doctor.
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    p.gender,
    COUNT(DISTINCT a.doctor_id) AS num_doc
FROM
    patients p
    JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name,
    p.gender
HAVING
    COUNT(DISTINCT a.doctor_id) > 1;

-- 13. Show doctors who have appointments in more than one department.
SELECT
    d.doctor_id,
    d.name,
    d.gender,
    d.phone_number,
    COUNT(DISTINCT doc.department_id) AS num_departments
FROM
    appointments a
    JOIN doctors d ON a.doctor_id = d.doctor_id
    JOIN departments doc ON d.department_id = doc.department_id
GROUP BY
    d.doctor_id,
    d.name,
    d.gender,
    d.phone_number
HAVING
    COUNT(DISTINCT doc.department_id) > 1;

-- 14. Find the most common diagnosis (treatment reason) across all patients.
SELECT
    diagnosis,
    COUNT(diagnosis)
FROM
    visit_records
GROUP BY
    diagnosis
ORDER BY
    COUNT(diagnosis) DESC;

-- 15. List patients who had consecutive missed appointments (No-show).
SELECT
    patient_id,
    appointment_id,
    appointment_date,
    status
FROM
    (
        SELECT
            patient_id,
            appointment_id,
            appointment_date,
            status,
            LAG(status) OVER (
                PARTITION BY patient_id
                ORDER BY
                    appointment_date
            ) AS prev_status
        FROM
            appointments
    ) sub
WHERE
    status = 'No-show'
    AND prev_status = 'No-show'
ORDER BY
    patient_id,
    appointment_date;

-- 16. Get the average length of treatment (difference between first and last visit) per patient.
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    p.registered_date,
    MAX(a.appointment_date) AS last_visit,
    AGE(MAX(a.appointment_date), p.registered_date)
FROM
    patients p
    LEFT JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name,
    p.registered_date;

-- 17. Show the top 3 most expensive treatments and the patients who received them.
SELECT
    t.treatment_name,
    p.first_name,
    p.last_name,
    t.cost
FROM
    treatments t
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN patients p ON p.patient_id = a.patient_id
ORDER BY
    cost DESC
LIMIT 3;

-- 18. Find all appointments where patient and doctor belong to the same city.
-- Note: Query not possible as city data is embedded in address text field

-- 19. Retrieve doctors who don’t have any appointments yet.
SELECT
    d.doctor_id,
    d.name,
    d.gender,
    d.phone_number
FROM
    doctors d
    LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
WHERE
    a.appointment_id IS NULL;

-- 20. Get the trend of appointments over time (group by month and year).
SELECT
    COUNT(DISTINCT appointment_id) AS number_of_appointment,
    EXTRACT(MONTH FROM appointment_date) AS months,
    EXTRACT(YEAR FROM appointment_date) AS years
FROM
    appointments
GROUP BY
    months,
    years
ORDER BY
    months;

-- 21. List all patients along with their assigned doctors and upcoming appointment dates.
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.gender,
    d.name AS doctor_name,
    MAX(a.appointment_date) AS upcoming_appointment
FROM
    patients p
    JOIN appointments a ON p.patient_id = a.patient_id
    JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY
    patient_name,
    p.gender,
    doctor_name;

-- 22. Find the top 5 doctors with the highest number of completed appointments.
SELECT
    a.doctor_id,
    d.name,
    COUNT(*) FILTER (
        WHERE
            a.status = 'Completed'
    ) AS comp
FROM
    appointments a
    JOIN doctors d ON d.doctor_id = a.doctor_id
GROUP BY
    a.doctor_id,
    d.name
ORDER BY
    comp DESC
LIMIT 5;

-- 23. Retrieve the total revenue generated from treatments in each department.
SELECT
    dep.department_name,
    SUM(t.cost) AS total_revenue
FROM
    treatments t
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN doctors d ON a.doctor_id = d.doctor_id
    JOIN departments dep ON dep.department_id = d.department_id
GROUP BY
    dep.department_name;

-- 24. Show all patients who had more than 3 visits in the last 6 months.
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    p.gender,
    COUNT(v.visit_id) AS no_of_visit
FROM
    patients p
    JOIN visit_records v ON p.patient_id = v.patient_id
WHERE
    visit_date BETWEEN CURRENT_DATE - INTERVAL '6 months'
    AND CURRENT_DATE
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name,
    p.gender
HAVING
    COUNT(v.visit_id) > 3
ORDER BY
    no_of_visit DESC;

-- 25. Find the average treatment cost per department.
SELECT
    dep.department_name,
    AVG(t.cost) AS average_treatment_cost
FROM
    treatments t
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN doctors d ON d.doctor_id = a.doctor_id
    JOIN departments dep ON dep.department_id = d.department_id
GROUP BY
    dep.department_name;

-- 26. Get the list of patients who never missed an appointment (no 'No-show').
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.gender
FROM
    patients p
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            appointments a
        WHERE
            p.patient_id = a.patient_id
            AND a.status = 'No-show'
    );

-- 27. Retrieve doctors who are specialized in more than one department (if applicable).
SELECT
    d.doctor_id,
    d.name,
    COUNT(DISTINCT d.specialization) AS no_of_specialization
FROM
    doctors d
    JOIN departments dep ON d.department_id = dep.department_id
GROUP BY
    d.doctor_id,
    d.name
HAVING
    COUNT(DISTINCT d.specialization) > 1;

-- 28. List patients along with their last treatment date and treatment type.
SELECT
    patient_id,
    patient_name,
    gender,
    treatment_name
FROM
    (
        SELECT
            p.patient_id,
            CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
            p.gender,
            t.treatment_date,
            t.treatment_name,
            ROW_NUMBER() OVER (
                PARTITION BY p.patient_id
                ORDER BY
                    t.treatment_id DESC
            ) AS rn
        FROM
            patients p
            JOIN appointments a ON p.patient_id = a.patient_id
            JOIN treatments t ON t.appointment_id = a.appointment_id
    ) sub
WHERE
    rn = 1;

-- 29. Show the trend of appointments per month in 2025.
SELECT
    EXTRACT(MONTH FROM appointment_date) AS months,
    EXTRACT(YEAR FROM appointment_date) AS years,
    COUNT(appointment_id) AS number_of_appointments
FROM
    appointments
WHERE
    EXTRACT(YEAR FROM appointment_date) = 2025
GROUP BY
    months,
    years;

-- 30. Find the patient who spent the maximum amount on treatments.
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.gender,
    SUM(t.cost) AS total_amount
FROM
    treatments t
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN patients p ON a.patient_id = p.patient_id
GROUP BY
    p.patient_id,
    patient_name,
    p.gender
ORDER BY
    SUM(t.cost) DESC
LIMIT 1;

-- 31. Retrieve the doctor with the highest number of unique patients treated.
SELECT
    a.doctor_id,
    d.name,
    COUNT(DISTINCT a.patient_id) AS number_of_treat
FROM
    appointments a
    JOIN doctors d ON d.doctor_id = a.doctor_id
WHERE
    a.status = 'Completed'
GROUP BY
    a.doctor_id,
    d.name
HAVING
    COUNT(DISTINCT a.patient_id) > 0
ORDER BY
    number_of_treat DESC;

-- 32. List all bills where the payment status is 'Pending' and appointment date is past due.
SELECT
    billing_id
FROM
    billing
WHERE
    payment_status = 'Pending'
    AND due_date < CURRENT_DATE;

-- 33. Get the ratio of 'No-show' vs 'Completed' appointments per department.
SELECT
    dep.department_name,
    COUNT(*) FILTER (
        WHERE
            a.status = 'Completed'
    ) AS completed,
    COUNT(*) FILTER (
        WHERE
            a.status = 'No-show'
    ) AS no_show,
    SUM(COUNT(*)) OVER () AS total_appointment,
    CONCAT(
        ROUND(
            (
                COUNT(*) FILTER (
                    WHERE
                        a.status = 'Completed'
                ) * 100.0 / SUM(COUNT(*)) OVER ()
            ),
            2
        ),
        '%'
    ) AS completed_ratio,
    CONCAT(
        ROUND(
            (
                COUNT(*) FILTER (
                    WHERE
                        a.status = 'No-show'
                ) * 100.0 / SUM(COUNT(*)) OVER ()
            ),
            2
        ),
        '%'
    ) AS no_show_ratio
FROM
    appointments a
    JOIN doctors d ON d.doctor_id = a.doctor_id
    JOIN departments dep ON d.department_id = dep.department_id
GROUP BY
    dep.department_name;

-- 34. Find which treatment type is most common among patients above 50 years old.
-- Note: Not possible, age/DOB column is missing in patients table

-- 35. Show patient name, treatment name and total cost for patients who took more than one treatment.
SELECT
    patient_id,
    patient_name,
    treatment_name,
    total_cost
FROM
    (
        SELECT
            p.patient_id,
            CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
            t.treatment_name,
            t.cost,
            COUNT(t.treatment_id) OVER (PARTITION BY p.patient_id) AS rn,
            SUM(t.cost) OVER (PARTITION BY p.patient_id) AS total_cost
        FROM
            treatments t
            JOIN appointments a ON t.appointment_id = a.appointment_id
            JOIN patients p ON p.patient_id = a.patient_id
    ) sub
WHERE
    rn > 1;

-- 36. Generate a report of total appointments, completed appointments, and no-shows by doctor.
SELECT
    d.doctor_id,
    d.name,
    COUNT(*) FILTER (
        WHERE
            a.status = 'Completed'
    ) AS complete_appointment,
    COUNT(*) FILTER (
        WHERE
            a.status = 'No-show'
    ) AS no_show_appointment
FROM
    appointments a
    JOIN doctors d ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id,
    d.name;

-- 37. Find all patients who had chemotherapy as treatment and their assigned doctor.
SELECT
    t.treatment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    t.treatment_name,
    d.doctor_id,
    d.name AS doctor_name
FROM
    treatments t
    JOIN appointments a ON t.appointment_id = a.appointment_id
    JOIN patients p ON p.patient_id = a.patient_id
    JOIN doctors d ON d.doctor_id = a.doctor_id
WHERE
    t.treatment_name = 'Chemotherapy'
ORDER BY
    treatment_id;

-- 38. Retrieve the department with the highest number of appointments.
SELECT
    dep.department_name,
    COUNT(a.appointment_id) AS num_of_app
FROM
    appointments a
    JOIN doctors d ON d.doctor_id = a.doctor_id
    JOIN departments dep ON dep.department_id = d.department_id
GROUP BY
    dep.department_name
ORDER BY
    num_of_app DESC
LIMIT 1;

-- 39. Show the average time difference (in days) between appointment scheduling and actual appointment date.
-- Note: Not possible, scheduling date column is missing in appointments table

-- 40. Get the list of doctors who never had a 'No-show' appointment.
SELECT
    doctor_id,
    name
FROM
    (
        SELECT
            d.doctor_id,
            d.name,
            COUNT(*) FILTER (
                WHERE
                    a.status = 'No-show'
            ) AS no_show_appointment
        FROM
            appointments a
            JOIN doctors d ON d.doctor_id = a.doctor_id
        GROUP BY
            d.doctor_id,
            d.name
    ) sub
WHERE
    no_show_appointment = 0;