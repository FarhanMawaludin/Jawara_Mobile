import 'package:flutter/material.dart';
import 'package:jawaramobile/core/component/InputField.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Warga',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[300], height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown Pilih Keluarga
              const Text('Pilih Keluarga'),
              const SizedBox(height: 5),
              // DropdownButtonFormField<String>(
              //   decoration: InputDecoration(
              //     hintText: 'Pilih Keluarga',
              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              //   ),
              //   initialValue: _keluargaTerpilih,
              //   items: _daftarKeluarga
              //       .map((keluarga) => DropdownMenuItem(
              //             value: keluarga,
              //             child: Text(keluarga),
              //           ))
              //       .toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       _keluargaTerpilih = value;
              //     });
              //   },
              // ),
              const SizedBox(height: 16),


              // Input Nama
              InputField(label: "Pilih Keluarga", hintText: "Pilih Pilih Keluarga",options: ["Keluarga Farhan","Keluarga Rendha","Keluarga Reika","Keluarga Nafa","Keluarga Fateh"],),
              InputField(label: "Nama", hintText: "Masukkan Nama Lengkap"),
              InputField(label: "Nik", hintText: "Masukkan NIK sesuai KTP"),
              InputField(label: "No. Telepon", hintText: "08xxxxxxxxxx"),
              InputField(label: "Tempat Lahir", hintText: "Masukkan tempat lahir"),
              InputField(label: "Golongan Darah", hintText: "Masukkan golongan darah"),
              InputField(label: "Peran Keluarga", hintText: "Masukkan peran keluarga"),
              InputField(label: "Pendidikan Terakhir", hintText: "Masukkan pendidikan terakhir"),
              InputField(label: "Pekerjaan", hintText: "Masukkan pekerjaan"),
              InputField(label: "Status", hintText: "Masukkan status"),

              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4), // Warna ungu muda seperti gambar
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data Warga Disimpan')),
                      );
                    }
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk text field agar tidak berulang
  Widget buildTextField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }
}