import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';
import 'login_view.dart';

class PolizaView extends StatelessWidget {
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();
  final _propietarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<PolizaViewModel>(context);

    _valorController.text = vm.valorSeguroAuto.toString();
    _accidentesController.text = vm.accidentes.toString();
    _propietarioController.text = vm.propietario;

    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Póliza", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1565C0),
        elevation: 0,
        actions: [
          Consumer<LoginViewModel>(
            builder: (context, loginVM, _) => IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () => _showLogoutDialog(context, loginVM),
              tooltip: 'Cerrar sesión',
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),

        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInput("Propietario", _propietarioController, (val) {
              vm.propietario = val;
              vm.notifyListeners();
            }),
            SizedBox(height: 12),
            _buildInput("Valor del ", _valorController, (val) {
              vm.valorSeguroAuto = double.tryParse(val) ?? 0;
              vm.notifyListeners();
            }, keyboard: TextInputType.number),
            SizedBox(height: 12),

            Text("Modelo de auto:", style: Theme.of(context).textTheme.titleLarge),
            for (var m in ['A','B','C'])
              _buildRadio("Modelo $m", m, vm.modeloAuto, (val) {
                vm.modeloAuto = val!;
                vm.notifyListeners();
              }),

            SizedBox(height: 12),
            Text("Edad propietario:", style: Theme.of(context).textTheme.titleLarge),
            for (var e in ['18-23', '23-55', '55+'])
              _buildRadio(_textoEdad(e), e, vm.edadPropietario, (val) {
                vm.edadPropietario = val!;
                vm.notifyListeners();
              }),

            SizedBox(height: 12),
            _buildInput("Número de accidentes", _accidentesController, (val) {
              vm.accidentes = int.tryParse(val) ?? 0;
              vm.notifyListeners();
            }, keyboard: TextInputType.number),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Color(0xFF1565C0),
                ),
                onPressed: vm.calcularPoliza,
                child: Text("CREAR PÓLIZA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20),

            Text(
              "Costo total: \$${vm.costoTotal.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, Function(String) onChanged, {TextInputType? keyboard}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }

  Widget _buildRadio(String label, String value, String groupValue, Function(String?) onChanged) {
    return RadioListTile(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: Color(0xFF1565C0),
    );
  }

  String _textoEdad(String rango) {
    switch (rango) {
      case '18-23': return 'Mayor igual a 18 y menor a 23';
      case '23-55': return 'Mayor igual a 23 y menor a 55';
      default: return 'Mayor igual 55';
    }
  }

  void _showLogoutDialog(BuildContext context, LoginViewModel loginVM) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Color(0xFF1565C0)),
              SizedBox(width: 10),
              Text('Cerrar Sesión'),
            ],
          ),
          content: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.grey[600])),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1565C0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                Navigator.of(context).pop();
                await loginVM.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

