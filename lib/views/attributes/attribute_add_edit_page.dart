import 'package:flutter/material.dart';
import '../../data/models/attribute_model.dart';
import '../../data/services/attribute_service.dart';

class AttributeFormPage extends StatefulWidget {
  final AttributeModel? attribute;

  const AttributeFormPage({super.key, this.attribute});

  @override
  State<AttributeFormPage> createState() => _AttributeFormPageState();
}

class _AttributeFormPageState extends State<AttributeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final valueController = TextEditingController();

  bool isActive = true;
  bool isSearchable = false;
  bool isFilterable = false;
  bool isColorAttribute = false;

  final service = AttributeService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.attribute != null) {
      final a = widget.attribute!;
      nameController.text = a.name;
      valueController.text = a.attributeValues.join(" | ");
      isActive = a.isActive;
      isSearchable = widget.attribute?.isSearchable ?? false;
      isFilterable = a.isFilterable;
      isColorAttribute = a.isColorAttribute;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    valueController.dispose();
    super.dispose();
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      final values = valueController.text
          .split("|")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final model = AttributeModel(
        id: widget.attribute?.id ?? "",
        name: nameController.text.trim(),
        attributeValues: values,
        isActive: isActive,
        isSearchable: isSearchable,
        isFilterable: isFilterable,
        isColorAttribute: isColorAttribute,
      );

      if (widget.attribute == null) {
        await service.create(model);
      } else {
        await service.update(model);
      }

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.attribute != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1A1C24),
        title: Text(
          isEditing ? "Update Attribute" : "Create Attribute",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Attribute Information",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1C24),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: nameController,
                    validator: (v) =>
                        v!.trim().isEmpty ? "Name is required" : null,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "e.g. Size",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.label_outline),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: valueController,
                    validator: (v) =>
                        v!.trim().isEmpty ? "Values are required" : null,
                    decoration: InputDecoration(
                      labelText: "Values (separated by |)",
                      hintText: "e.g. small | medium | large",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.list_alt_rounded),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1C24),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text("Active"),
                    subtitle: const Text("Enable this attribute in the system"),
                    value: isActive,
                    onChanged: (v) => setState(() => isActive = v),
                    activeColor: Colors.indigoAccent,
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: Row(
                      children: [
                        const Text("Searchable"),
                        const SizedBox(width: 8),
                        Tooltip(
                          message:
                              "Allow user to filter product based on this attribute",
                          child: const Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    subtitle: const Text("Can be used in search filters"),
                    value: isSearchable,
                    onChanged: (v) => setState(() => isSearchable = v),
                    activeColor: Colors.indigoAccent,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              isEditing
                                  ? "UPDATE ATTRIBUTE"
                                  : "CREATE ATTRIBUTE",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
