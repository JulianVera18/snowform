output "schemas" {
  description = "Mapa de schemas creados, con su base de datos, nombre, id y otros atributos opcionales"
  value = {
    for key, sch in snowflake_schema.schema :
    key => {
      database = sch.database
      name     = sch.name
      id       = sch.id
      comment  = sch.comment
    }
  }
}
