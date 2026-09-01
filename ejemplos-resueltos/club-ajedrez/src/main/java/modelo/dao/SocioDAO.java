package modelo.dao;

import modelo.vo.Socio;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class SocioDAO {
    private final List<Socio> lista = new ArrayList<>();
    private int proximoId = 1;

    public SocioDAO() {
        Socio s1 = new Socio("Ana", "García", LocalDate.of(2010, 3, 15), "Juvenil");
        s1.setPagoAlDia(true);
        agregar(s1);

        Socio s2 = new Socio("Carlos", "López", LocalDate.of(1990, 7, 22), "Adulto");
        s2.setPagoAlDia(false);
        agregar(s2);
    }

    public void agregar(Socio socio) {
        socio.setId(proximoId++);
        lista.add(socio);
    }

    public List<Socio> getLista() {
        return new ArrayList<>(lista);
    }

    public void eliminar(int id) {
        lista.removeIf(s -> s.getId() == id);
    }
}
