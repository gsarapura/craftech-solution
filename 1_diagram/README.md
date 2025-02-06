# DIAGRAM
## Prueba 1: Diagrama de Red 
Produzca un diagrama de red (puede utilizar lucidchart) de una aplicación web en GCP o AWS y escriba una descripción de
texto de 1/2 a 1 página de sus elecciones y arquitectura.

El diseño debe soportar:
- Cargas variables
- Contar con HA (alta disponibilidad)
- Frontend en Js
- Backend con una base de datos relacional y una no relacional
- La aplicación backend consume 2 microservicios externos

El diagrama debe hacer un mejor uso de las soluciones distribuidas.

## Solution
### Architecture Description

For this web application, I have chosen to use AWS (Amazon Web Services) due to its robustness and flexibility in implementing distributed solutions. The architecture is designed to handle variable loads and ensure high availability (HA), which is essential for maintaining system performance and reliability.
Ensuring HA means ensuring that a system continues functioning despite of components failing. In AWS, making component available in different Availability Zones.

### Frontend

The frontend of the application is developed in JavaScript, utilizing a modern framework such as React or Angular. This frontend is deployed on Amazon S3 as a static website, allowing for fast and efficient access for end users. To manage traffic and improve user experience, I employ Amazon CloudFront as a content delivery network (CDN).
- S3: General purpose - It will be across different AZ.

### Backend
* The backend consists of two main parts: a relational database and a non-relational database.
    - Relational Database: I use Amazon RDS (Relational Database Service) with PostgreSQL. This database efficiently handles structured data, providing scalability and replication features, thus ensuring high availability.

    - Non-relational Database: I opt for Amazon DynamoDB, which is highly scalable and allows for fast access to unstructured data. This is useful for managing information such as user logs or real-time data that may vary in structure.

### External Microservices
??? LAMBDA
The backend application is designed to consume two external microservices. I use AWS Lambda to manage these integrations, allowing for serverless execution and automatic scaling, ensuring the system can handle traffic spikes without compromising performance.

### High Availability

To ensure high availability, I implement an Application Load Balancer (ELB) that distributes incoming requests among backend instances. Additionally, the EC2 instances running the backend are distributed across multiple Availability Zones to minimize the risk of downtime.

Lastly, CloudWatch and AWS CloudTrail are implemented to monitor the application's performance and security, enabling quick responses to any issues.????

### Conclusion

This architecture on AWS provides a scalable and resilient approach capable of handling variable loads while ensuring high availability, which is fundamental to the success of the application. Furthermore, the use of distributed solutions optimizes performance and operational efficiency.
Diagram

