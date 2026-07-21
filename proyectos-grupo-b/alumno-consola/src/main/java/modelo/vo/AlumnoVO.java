package modelo.vo;

public class AlumnoVO extends PersonaVO {
    private String telefono;

    // Constructor vacío
    public AlumnoVO() {
        super();
    }

    // Constructor completo (código, nombre y teléfono)
    public AlumnoVO(int codigo, String nombre, String telefono) {
        super(codigo, nombre);
        this.telefono = telefono;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    @Override
    public String toString() {
        return "AlumnoVO{" +
                "codigo=" + getCodigo() +
                ", nombre='" + getNombre() + '\'' +
                ", telefono='" + telefono + '\'' +
                '}';
    }
}
