use testcontainers::{clients, core::WaitFor, images::postgres::Postgres};
use tokio::test;
use tokio_postgres::Row;
use std::env;
use dotenv::dotenv;

#[derive(Debug)]
pub struct User {
    pub id: i32,
    pub username: String,
    pub password: String,
    pub email: String,
}

impl From<Row> for User {
    fn from(row: Row) -> Self {
        Self {
            id: row.get("id"),
            username: row.get("username"),
            password: row.get("password"),
            email: row.get("email"),
        }
    }
}

#[test]
async fn it_works() {
    dotenv().ok();
    let docker = clients::Cli::default();

    // Define a PostgreSQL container image
    let postgres_image = Postgres::default();

    let pg_container = docker.run(postgres_image);

    pg_container.start();

    WaitFor::seconds(60);

    // Get the PostgreSQL port
    let pg_port = pg_container.get_host_port_ipv4(5432);
    let user = env::var("POSTGRES_USER").unwrap();
    let password = env::var("POSTGRES_PASS").unwrap();
    
    // Conectar al contenedor PostgreSQL
    let initial_config = format!("host=localhost port={} user={} password={}", pg_port, user, password);
    let (initial_client, initial_connection) = tokio_postgres::connect(&initial_config, tokio_postgres::NoTls).await.unwrap();

    // Iniciar la tarea de conexión para manejar I/O asíncrono
    tokio::spawn(async move {
        if let Err(e) = initial_connection.await {
            eprintln!("Connection error: {}", e);
        }
    });
   
    initial_client.batch_execute("CREATE DATABASE petstore_database_test").await.unwrap();
    println!("Base de datos 'petstore' creada con éxito.");

         
    let (client, connection) = tokio_postgres::Config::new()
    .user(env::var("POSTGRES_USER").unwrap())
    .password(env::var("POSTGRES_PASS").unwrap())
    .host("localhost")
    .port(pg_port)
    .dbname("petstore_database_test")
    //petstore
    .connect(tokio_postgres::NoTls)
    .await
    .unwrap();

     // Spawn connection
     tokio::spawn(async move {
        if let Err(error) = connection.await {
            eprintln!("Connection error: {}", error);
        }
    });
    let _ = client
        .batch_execute(
            "
        CREATE TABLE IF NOT EXISTS app_user (
            id              SERIAL PRIMARY KEY,
            username        VARCHAR UNIQUE NOT NULL,
            password        VARCHAR NOT NULL,
            email           VARCHAR UNIQUE NOT NULL
            )
    ",
        )
        .await;

    let _ = client
        .execute(
            "INSERT INTO app_user (username, password, email) VALUES ($1, $2, $3)",
            &[&"user1", &"mypass", &"user@test.com"],
        )
        .await;

    let result = client
        .query("SELECT id, username, password, email FROM app_user", &[])
        .await
        .unwrap();

    let users: Vec<User> = result.into_iter().map(|row| User::from(row)).collect();

    let user = users.first().unwrap();

    assert_eq!(1, user.id);
    assert_eq!("user1", user.username);
    assert_eq!("mypass", user.password);
    assert_eq!("user@test.com", user.email);
    println!("User: {:#?}", user);
}

