import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/attribute_controller.dart';
import '../../data/models/attribute_model.dart';

class AttributeFormPage extends StatefulWidget {
  const AttributeFormPage({super.key, this.attribute});

  final AttributeModel? attribute;

  @override
  State<AttributeFormPage> createState() => _AttributeFormPageState();
}

class _AttributeFormPageState extends State<AttributeFormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _valuesController;

  late bool _isActive;
  late bool _isSearchable;
  late bool _isFilterable;
  late bool _isColorAttribute;

  @override
  void initState() {
    super.initState();
    final attribute = widget.attribute;
    _nameController = TextEditingController(text: attribute?.name ?? '');
    _valuesController = TextEditingController(
      text: attribute?.attributeValues.join(', ') ?? '',
    );
    _isActive = attribute?.isActive ?? true;
    _isSearchable = attribute?.isSearchable ?? false;
    _isFilterable = attribute?.isFilterable ?? false;
    _isColorAttribute = attribute?.isColorAttribute ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valuesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    final values = _valuesController.text
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    final model = AttributeModel(
      id: widget.attribute?.id ?? '',
      name: name,
      attributeValues: values,
      isActive: _isActive,
      isSearchable: _isSearchable,
      isFilterable: _isFilterable,
      isColorAttribute: _isColorAttribute,
      createdAt: widget.attribute?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final controller = context.read<AttributeController>();
    if (widget.attribute == null) {
      await controller.create(model);
    } else {
      await controller.update(model);
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.attribute == null ? 'Thêm thuộc tính' : 'Cập nhật thuộc tính',
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên thuộc tính',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _valuesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Danh sách giá trị',
                        hintText: 'Ví dụ: Đỏ, Xanh, Vàng',
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _isActive,
                      title: const Text('Kích hoạt'),
                      onChanged: (value) => setState(() => _isActive = value),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _isSearchable,
                      title: const Text('Cho phép tìm kiếm'),
                      onChanged: (value) => setState(() => _isSearchable = value),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _isFilterable,
                      title: const Text('Cho phép lọc'),
                      onChanged: (value) => setState(() => _isFilterable = value),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _isColorAttribute,
                      title: const Text('Thuộc tính màu sắc'),
                      onChanged: (value) =>
                          setState(() => _isColorAttribute = value),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _save,
                        child: Text(widget.attribute == null ? 'Tạo mới' : 'Lưu thay đổi'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
