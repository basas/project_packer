# Repo to create AMI image with Jenkins preconfigured.

-------------------------------------
Installs and configures Jenkins

- Store/update crediantials at secrets.config
- Run build.sh
    - Creates infrastructure: Security group to allow 8080 and 22 traffic
    - Use default vpc and subnets
    - Creates EBS volume and snapshot for packer parmanent storage
    - Executes packer to create AMI using Amazon Linux 2 image
    - Install updates
    - Install kernel live paches
    - mounts permanent storage
    - install Jenkins
    - Configure Jenkins, Uploads plugins, Sets authorization and admin passwd from secrets.config
    - Sets Jenkins aws crediantials
    - Creates simple JOB for pipeline
    - Packs everything to AMI and cleans up
- Run deploy.sh
    - Spins EC2 instance with Jenkins preinstalled
    - Jenkins job for pipeline created: 
        - Pipeline fetched from https://github.com/basas/simplecicd.git
        - Pipeline creates ec2 instance and install Docker Monitoring system
        - GIT repository : https://github.com/basas/docker_monitor.git
        - Cookbook install docker and few images: 
            - node_exporter
            - cadvisor
            - prometheus
            - grafana
        - Grafana web interface is accessible via internet
    
    