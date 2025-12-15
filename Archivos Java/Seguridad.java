import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

public class Seguridad {

    /**
     * Convierte un texto normal a su hash SHA-256 hexadecimal.
     */
    public static String codificar(String password) {
        try {
            // 1. Obtener instancia del algoritmo SHA-256
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            
            // 2. Aplicar el hash al array de bytes de la contraseña
            byte[] hashBytes = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            
            // 3. Convertir los bytes a formato Hexadecimal (String legible)
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                // Truco matemático para convertir byte a hex de 2 caracteres
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}