import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyAppHome(),
    ),
  );
}

class MyAppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Flutter Drywall App');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    PaginaInicio(),
    IngresarPacientes(),
    IngresarDatosPaciente(),
    Page3(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Expediente'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Ingresar datos del paciente'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Historial del paciente'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaginaInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Contenido de la Página de Inicio'),
    );
  }
}

class IngresarPacientes extends StatefulWidget {
  @override
  _IngresarPacientesState createState() => _IngresarPacientesState();
}

class _IngresarPacientesState extends State<IngresarPacientes> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _fechaIngresoController = TextEditingController();
  final TextEditingController _diagnosticoController = TextEditingController();

  // Referencia a la colección 'pacientes' en Firestore
  final CollectionReference _pacientesCollection =
      FirebaseFirestore.instance.collection('pacientes');

  void _registrarPaciente() async {
    // Obtener los valores del formulario
    String nombre = _nombreController.text;
    int edad = int.tryParse(_edadController.text) ?? 0;
    String fechaIngreso = _fechaIngresoController.text;
    String diagnostico = _diagnosticoController.text;

    // Validar que el nombre no esté vacío
    if (nombre.isNotEmpty) {
      // Guardar el paciente en Firestore
      await _pacientesCollection.add({
        'nombre': nombre,
        'edad': edad,
        'fechaIngreso': fechaIngreso,
        'diagnostico': diagnostico,
      });

      // Limpiar los campos después de guardar
      _nombreController.clear();
      _edadController.clear();
      _fechaIngresoController.clear();
      _diagnosticoController.clear();

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paciente registrado con éxito')),
      );
    } else {
      // Mostrar un mensaje de error si el nombre está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese el nombre del paciente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registrar Paciente',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _nombreController,
            decoration: InputDecoration(labelText: 'Nombre del Paciente'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _edadController,
            decoration: InputDecoration(labelText: 'Edad del Paciente'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _fechaIngresoController,
            decoration: InputDecoration(labelText: 'Fecha de Ingreso'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _diagnosticoController,
            decoration: InputDecoration(labelText: 'Diagnóstico'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _registrarPaciente,
            child: Text('Registrar Paciente'),
          ),
        ],
      ),
    );
  }
}

class IngresarDatosPaciente extends StatefulWidget {
  @override
  _IngresarDatosPacienteState createState() => _IngresarDatosPacienteState();
}

class _IngresarDatosPacienteState extends State<IngresarDatosPaciente> {
  late Future<List<Map<String, dynamic>>> _historialFuture;

  @override
  void initState() {
    super.initState();
    _historialFuture = getDatos();
  }

  Future<void> _actualizarHistorial() async {
    setState(() {
      _historialFuture = getDatos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _historialFuture,
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error al obtener los datos');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No hay datos disponibles');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> paciente = snapshot.data![index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Nombre: ${paciente['nombre']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Edad: ${paciente['edad']}'),
                      Text('Fecha de Ingreso: ${paciente['fechaIngreso']}'),
                      Text('Diagnóstico: ${paciente['diagnostico']}'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> getDatos() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pacientes').get();

    return querySnapshot.docs
        .map((documento) => documento.data() as Map<String, dynamic>)
        .toList();
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Contenido de Historial del paciente'),
    );
  }
}
