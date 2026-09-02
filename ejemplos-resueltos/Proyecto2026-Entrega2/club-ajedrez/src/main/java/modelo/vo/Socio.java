package modelo.vo;

import java.time.LocalDate;
import java.time.Period;

public class Socio extends Persona {

    private int id;
    private LocalDate fechaNacimiento;
    private String categoria;
    private boolean pagoAlDia;

    public Socio(
            String nombre,
            String apellido,
            LocalDate fechaNacimiento,
            String categoria) {

        super(nombre, apellido);
        this.fechaNacimiento = fechaNacimiento;
        this.categoria = categoria;
        this.pagoAlDia = false;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(LocalDate fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public boolean isPagoAlDia() {
        return pagoAlDia;
    }

    public void setPagoAlDia(boolean pagoAlDia) {
        this.pagoAlDia = pagoAlDia;
    }

    public int getEdad() {
        return Period
                .between(fechaNacimiento, LocalDate.now())
                .getYears();
    }

    @Override
    public String toString() {
        return "Socio{" +
                "id=" + id +
                ", nombre=" + getNombre() + " " + getApellido() +
                ", edad=" + getEdad() +
                ", categoria=" + categoria +
                "}";
    }
}
