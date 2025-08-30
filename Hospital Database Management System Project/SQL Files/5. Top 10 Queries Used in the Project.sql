--1. Doctor who generated the highest total revenue.
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

--2. Total revenue generated from treatments in each department
SELECT
    dep.department_name, SUM(t.cost) AS total_revenue
FROM
    treatments t
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN doctors d ON a.doctor_id = d.doctor_id
    JOIN departments dep ON dep.department_id = d.department_id
GROUP BY
    dep.department_name order by total_revenue desc;

--3. Patient who spent the maximum amount on treatments
SELECT
    p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
	p.gender, SUM(t.cost) AS total_amount
FROM
    treatments t
    JOIN appointments a ON a.appointment_id = t.appointment_id
    JOIN patients p ON a.patient_id = p.patient_id
GROUP BY
    p.patient_id, patient_name, p.gender
ORDER BY
    SUM(t.cost) DESC
LIMIT 1;

--4. Top 5 doctors who handled the most appointments
SELECT
    a.doctor_id, d.name, COUNT(a.appointment_id) AS Number_of_handle
FROM
    appointments a 
    JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY
    a.doctor_id, d.name
ORDER BY
    COUNT(a.appointment_id) DESC
LIMIT 5;

--5. Top 5 doctors with highest completed appointments
SELECT
    a.doctor_id, d.name, COUNT(*) FILTER(WHERE a.status = 'Completed') AS completed
FROM
    appointments a
    JOIN doctors d ON d.doctor_id = a.doctor_id
GROUP BY
    a.doctor_id, d.name
ORDER BY
    completed DESC
LIMIT 5;

--6. Doctor with the highest number of unique patients treated
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

--7. Patients who spent more than 10,000 in total treatment costs
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

--8. Patients with more than 3 visits in the last 6 months
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
    no_of_visit DESC limit 10;

--9. Ratio of 'No-show' vs 'Completed' appointments per department
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
    dep.department_name order by no_show_ratio desc;

--10. Department with the highest number of appointments
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
