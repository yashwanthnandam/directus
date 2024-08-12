services:
  mariadb:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10.5
    container_name: mariadb
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8.0.27
    #command: '--default-authentication-plugin=mysql_native_password'
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    x-tinkr:
      load_balancer:
        tenancy: dedicated
        type: network
        network: private
    environment:
      - MYSQL_ROOT_PASSWORD=directus
      - MYSQL_DATABASE=directus
      - MYSQL_USER=directus
      - MYSQL_PASSWORD=directus
    networks:
      - database
    ports:
      - 3306:3306
      
  directus:
    image: directus/directus:latest
    container_name: directus
    ports:
      - 8055:8055
    restart: always
    x-tinkr:
      cpu: 512
      memory: 512
      environment: 
        - DB_HOST=<hostname:mariadb>
      load_balancer:
        tenancy: dedicated
        type: webserver
        healthcheck:
          timeout: 10
          healthy-threshold: 3
          unhealthy-threshold: 5
          port: 80
          path: /
          interval: 120
          success_code: "301-302"
    networks:
      - database
    environment:
      - KEY=3579757c-be70-4eb3-8bc0-2d089e1acde5
      - SECRET=4edf7e4a-274c-4b66-971b-83e0848710e7
      - ADMIN_EMAIL=admin@example.com
      - ADMIN_PASSWORD=t1nkrDirectus
      - DB_CLIENT=mysql
      - DB_HOST=mariadb
      - DB_DATABASE=directus
      - DB_USER=directus
      - DB_PASSWORD=directus
      - DB_PORT=3306

networks:
  database:
    driver: bridge

volumes:
  db_data:
