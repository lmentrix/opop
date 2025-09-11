import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/features/discovery/data/models/explore_map_model.dart';

class ExploreMapWidget extends StatefulWidget {
  const ExploreMapWidget({super.key});

  @override
  State<ExploreMapWidget> createState() => _ExploreMapWidgetState();
}

class _ExploreMapWidgetState extends State<ExploreMapWidget> {
  final MapController _mapController = MapController();
  final List<NearbyPerson> _nearbyPeople =
      ExploreMapData.getDummyNearbyPeople();
  NearbyPerson? _selectedPerson;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: ExploreMapData.vancouverCenter,
            initialZoom: 13,
            minZoom: 10,
            maxZoom: 18,
            onTap: (_, __) {
              setState(() {
                _selectedPerson = null;
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.opop',
            ),
            MarkerLayer(
              markers: _nearbyPeople.map((person) {
                return Marker(
                  point: person.position,
                  width: 60,
                  height: 60,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPerson = person;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(
                                int.parse(
                                  ExploreMapData.getMBTIColor(
                                    person.mbtiType,
                                  ).substring(1),
                                  radix: 16,
                                ),
                              ),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: person.avatar.startsWith('assets')
                                ? AssetImage(person.avatar) as ImageProvider
                                : NetworkImage(person.avatar),
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                        if (person.isOnline)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        if (_selectedPerson != null)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _buildPersonCard(_selectedPerson!),
          ),
        Positioned(
          top: 50,
          right: 20,
          child: Column(
            children: [
              _buildMapControlButton(
                icon: Icons.my_location,
                onPressed: _centerMapOnVancouver,
              ),
              const SizedBox(height: 10),
              _buildMapControlButton(
                icon: Icons.zoom_in,
                onPressed: () {
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildMapControlButton(
                icon: Icons.zoom_out,
                onPressed: () {
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonCard(NearbyPerson person) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: person.avatar.startsWith('assets')
                    ? AssetImage(person.avatar) as ImageProvider
                    : NetworkImage(person.avatar),
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          person.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (person.isOnline)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Online',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse(
                                ExploreMapData.getMBTIColor(
                                  person.mbtiType,
                                ).substring(1),
                                radix: 16,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            person.mbtiType,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${person.distance.toStringAsFixed(1)} km away',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (person.personalityDescription != null) ...[
            const SizedBox(height: 8),
            Text(
              person.personalityDescription!,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            person.status,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement chat functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Message'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement profile view
                  },
                  child: const Text('View Profile'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(icon: Icon(icon, size: 20), onPressed: onPressed),
    );
  }

  void _centerMapOnVancouver() {
    _mapController.move(ExploreMapData.vancouverCenter, 13);
  }
}
