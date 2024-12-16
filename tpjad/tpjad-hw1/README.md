# TPJAD-HW1: Aplicație Containerizată cu Tomcat, WildFly și Jetty

## Informații despre student
- **Nume:** David Simonel-Olimpiu
- **Grupa:** 244

---

## Descrierea proiectului

Acest proiect propune o arhitectură distribuită containerizată care folosește **Tomcat**, **WildFly** și **Jetty** pentru a demonstra comunicarea între servicii într-un mediu orchestrator Kubernetes. Fiecare server găzduiește o aplicație modulară bazată pe servlet-uri Java, care gestionează fluxul cererilor HTTP. Soluția se concentrează pe interoperabilitate, scalabilitate și extensibilitate.

---

## Arhitectura și fluxul aplicației

1. **Tomcat**: Punct de intrare pentru utilizator, preia cererile și le transmite către **WildFly**.
2. **WildFly**: Primește cereri de la Tomcat, comunică cu **Jetty** pentru procesarea suplimentară și trimite răspunsul.
3. **Jetty**: Răspunde cererilor primite de la WildFly și furnizează răspunsul final.

Fluxul aplicației este:  
**Client** → **Tomcat** → **WildFly** → **Jetty** → **Răspuns final către client**

---

## Descrierea obiectelor folosite

### 1. Servleturi
Fiecare server implementează un servlet care gestionează cereri și răspunsuri. Protocoalele HTTP sunt folosite pentru comunicare între module.

#### Prototipuri:
- **TomcatServlet**:
    - **Parametri:**
        - `HttpServletRequest req` – cererea HTTP.
        - `HttpServletResponse resp` – răspunsul HTTP.
    - **Return:** Void, însă scrie răspunsul în fluxul de ieșire al obiectului `HttpServletResponse`.
    - **Excepții aruncate:**
        - `IOException` – în cazul erorilor de scriere.
        - `ServletException` – pentru erori legate de servlet.

- **WildFlyServlet** și **JettyServlet**: Structură similară cu `TomcatServlet`.

---

### 2. Clasa utilitară pentru cereri HTTP
Aceasta gestionează comunicarea dintre servere folosind metoda HTTP GET.

#### Prototipuri:
- **HttpRequestHelper.sendGet(String url): String**
    - **Parametri:**
        - `url` – URL-ul resursei la care se face cererea.
    - **Return:**
        - Răspunsul ca șir de caractere.
    - **Excepții aruncate:**
        - `IOException` – pentru erori de conexiune.
        - `MalformedURLException` – dacă URL-ul este invalid.

---

### 3. Configurații container și Kubernetes
Fiecare server are o configurație dedicată definită prin fișiere Docker și Kubernetes YAML.

#### Prototipuri:
- Fișiere **Dockerfile** configurează:
    - Imaginea de bază (e.g., `tomcat:9.0`, `wildfly:26.1`, `jetty:11.0`).
    - Copierea fișierelor WAR în directoarele corespunzătoare.
    - Expunerea porturilor.

- Fișiere **Kubernetes YAML** configurează:
    - **Deployment:** pentru lansarea modulelor în Kubernetes.
    - **Service:** pentru expunerea fiecărui modul în rețeaua internă a clusterului.

---

## Context operațional și testare

### Context de rulare
Soluția este operațională în următoarele condiții:
1. Toate resursele sunt configurate și aplicate corect în Kubernetes.
2. Fiecare imagine Docker este construită fără erori și împinsă în registry-ul Docker local sau Minikube.
3. Rularea scripturilor de testare validează funcționalitatea serviciilor și comunicarea între ele.

---

### Exemple de utilizare
- **Exemplu reușit:**
    - Cererea trimisă către Tomcat este procesată, iar răspunsul final de la Jetty ajunge la utilizator prin WildFly.
    - Răspuns așteptat:
      ```
      Jetty received from WildFly: Tomcat says hello!
      ```

- **Contraexemplu (eșec):**
    - WildFly este oprit sau inaccesibil. Rezultatul din Tomcat indică eroare de rețea:
      ```
      Error: Could not connect to WildFly.
      ```

---

## Observații și concluzii

### Observații:
- Arhitectura modulară facilitează depanarea și extinderea aplicației.
- Comunicarea între module este flexibilă datorită utilizării DNS-ului Kubernetes și a claselor Java standard.

### Concluzii:
Acest proiect demonstrează cum pot fi integrate diferite servere de aplicații într-un mediu containerizat, folosind tehnologii moderne precum Docker și Kubernetes. Soluția este extensibilă și oferă o bază solidă pentru dezvoltări ulterioare.