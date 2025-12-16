import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart'; // Pastikan sudah install flutter_map
import 'package:latlong2/latlong.dart'; // Pastikan sudah install latlong2
import '../../../providers/kegiatan_form_provider.dart';
import '../../pilih_lokasi.dart';

class LokasiKegiatanField extends ConsumerStatefulWidget {
  final Color primaryColor;

  const LokasiKegiatanField({
    super.key,
    this.primaryColor = const Color(0xFF6C63FF),
  });

  @override
  ConsumerState<LokasiKegiatanField> createState() => _LokasiKegiatanFieldState();
}

class _LokasiKegiatanFieldState extends ConsumerState<LokasiKegiatanField> {
  final TextEditingController _controller = TextEditingController();
  LatLng? _selectedCoordinates;

  @override
  void initState() {
    super.initState();
    // Sinkronisasi controller dengan state awal
    final initialValue = ref.read(kegiatanFormProvider).lokasi;
    _controller.text = initialValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );

    if (result != null) {
      setState(() {
        _selectedCoordinates = result;
      });
      
      // Disini idealnya pakai Geocoding untuk ubah LatLng jadi Alamat String
      // Untuk sementara kita format koordinatnya atau biarkan user isi detailnya
      String coordinateString = "${result.latitude.toStringAsFixed(5)}, ${result.longitude.toStringAsFixed(5)}";
      
      // Update text field (bisa diganti alamat asli jika ada package geocoding)
      _controller.text = coordinateString; 
      
      // Update state global
      ref.read(kegiatanFormProvider.notifier).updateLokasi(coordinateString);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen perubahan state dari luar (jika ada reset form)
    ref.listen(kegiatanFormProvider, (previous, next) {
      if (next.lokasi != _controller.text) {
        _controller.text = next.lokasi;
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container Utama
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              // Bagian Preview Map
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Map Preview (Static)
                      _selectedCoordinates != null
                          ? FlutterMap(
                              options: MapOptions(
                                initialCenter: _selectedCoordinates!,
                                initialZoom: 15.0,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.none, // Disable scroll/zoom di preview
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.jawara.mobile',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: _selectedCoordinates!,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.map_outlined, 
                                      size: 40, 
                                      color: Colors.grey[400]
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Belum ada lokasi dipilih",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      
                      // Tombol "Pin Point" Overlay
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          elevation: 3,
                          child: InkWell(
                            onTap: _pickLocation,
                            borderRadius: BorderRadius.circular(30),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12, 
                                vertical: 8
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.pin_drop_rounded, 
                                    size: 18, 
                                    color: widget.primaryColor
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Pin Point",
                                    style: TextStyle(
                                      color: widget.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bagian Input Text
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Detail Lokasi',
                    hintText: 'Nama jalan, gedung, atau patokan...',
                    prefixIcon: Icon(
                      Icons.location_on_outlined, 
                      color: Colors.grey[600], 
                      size: 20
                    ),
                    border: InputBorder.none, // Hilangkan border default
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 16
                    ),
                    floatingLabelStyle: TextStyle(color: widget.primaryColor),
                  ),
                  textCapitalization: TextCapitalization.words,
                  maxLines: 2,
                  minLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi wajib diisi';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    ref.read(kegiatanFormProvider.notifier).updateLokasi(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}