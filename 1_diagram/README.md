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
Ensuring HA means ensuring that a system continues functioning despite of components failing. In AWS, making component available in different Availability Zones is one of the main concerns to tacke in this solution.

### Frontend

The frontend of the application is developed in JavaScript, utilizing a modern framework such as React or Angular. This frontend is deployed on Amazon S3 as a static website, allowing for fast and efficient access for end users. To manage traffic and improve user experience, I employ Amazon CloudFront as a content delivery network (CDN) that then needs to configured with an external DNS provider, such as Cloudfare. 
- S3: General purpose - It will be across different AZ.

### Backend
* The backend consists of three parts: a relational database, a non-relational database and backend running on ECS (or Lambda for decoupling):
    - Relational Database: I use Amazon RDS (Relational Database Service) with PostgreSQL. This database efficiently handles structured data, providing scalability and replication features, thus ensuring high availability. Using at least two instances in different AZ can be beneficial for HA, but it's necessary to bear in mind costs.

    - Non-relational Database: I opt for Amazon DynamoDB, which is highly scalable and allows for fast access to unstructured data. This is useful for managing information such as user logs or real-time data that may vary in structure. 

    - ECS Backend: The backend application is hosted on Amazon ECS, where it processes core application logic and communicates with both the relational and non-relational databases. Alternatively, interactions with external microservices can be handled directly within ECS containers, or decoupled via AWS Lambda functions for more flexibility and scalability.

### External Microservices
If the external microservices are accessed occasionally or if the integration needs to be decoupled from the core backend logic, Lambda could be a more flexible solution. Lambda can be used to handle these external API calls when needed, making the architecture more modular. It's useful if the idea is that the backend (ECS) must be focused on core application logic, while Lambda handles external service interactions.
This idea is not implemented in the diagram since it needs more analysis from myself: what are other alternatives, how to implement it, etc. 


### VPC
This implementation uses two Availability Zones (AZs) to ensure high availability and fault tolerance. For Amazon RDS, the Multi-AZ deployment feature is enabled, meaning that the database is automatically replicated to a standby instance in a different AZ. In the event of a failure, the system can failover to the standby instance, minimizing downtime and ensuring continuous operation.
Additionally, communication between ECS and RDS is done via Security Group. One thing to add here is the access of developers to the DB, since it's in a private subnet and not publicly available, a solution via SSH tunneling or System Manager should be applied.

### High Availability

To ensure high availability, I implement an Application Load Balancer (ALB) that distributes incoming requests among backend instances. Additionally, the ECS running the backend is distributed across multiple Availability Zones to minimize the risk of downtime.

### Conclusion

This architecture on AWS provides a scalable and resilient approach capable of handling variable loads while ensuring high availability, which is fundamental to the success of the application. Furthermore, the use of distributed solutions optimizes performance and operational efficiency.

## Diagram
![Image](/1_diagram/DIAGRAM.png)

Done with LucidChart - [Link here](https://lucid.app/lucidchart/1c9c4e97-60d3-4fca-93f7-8c783c479064/edit?viewport_loc=-1949%2C-1511%2C4085%2C1760%2C0_0&invitationId=inv_7f08654f-37cd-4f9e-9d4c-f12b2226ee8e)


## Extras
### CI/CD
- GitHub Action that updates backend image in ECR and restarts ECS service. 

![Image](/1_diagram/PIPELINE_EXAMPLE.png)