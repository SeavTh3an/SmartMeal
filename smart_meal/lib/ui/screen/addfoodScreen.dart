import 'package:flutter/material.dart';
import '../../model/meal.dart';
import '../../model/nutrition.dart';
import 'mainScreen.dart';
import '../widget/header/curveHead.dart';
import '../widget/topNavigation.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _calController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  Category? _selectedCategory;
  bool _hasVegetables = false;

  void _submitMeal() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final meal = Meal(
        id: Meal.generateDisplayID(_selectedCategory!),
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        image: _imageController.text.trim().isEmpty
            ? 'assets/image/khmer_img/lots_food.jpg'
            : _imageController.text.trim(),
        category: _selectedCategory!,
        nutrition: Nutrition(
          calories: double.tryParse(_calController.text.trim()) ?? 0,
          protein: double.tryParse(_proteinController.text.trim()) ?? 0,
          sugar: double.tryParse(_sugarController.text.trim()) ?? 0,
          fat: double.tryParse(_fatController.text.trim()) ?? 0,
          vegetables: _hasVegetables,
        ),
        ingredients: _ingredientsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        cookingInstructions: _instructionsController.text.trim(),
      );

      MainScreen.of(context).addNewMealToList(meal);

      _formKey.currentState!.reset();
      setState(() {
        _selectedCategory = null;
        _hasVegetables = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Meal added successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }

  // Simple one box container style
  Widget _box({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // theme surface
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF608D43), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header 
          SliverToBoxAdapter(
            child: CurvedHeader(
              title: 'Add Food',
              onMenuTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (_) => TopMenuSheet(
                    currentIndex: 2,
                    onSelected: (index) {
                      MainScreen.of(context).changeTab(index);
                    },
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    'Add Your New Recipe',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // meal name and category
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Meal Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  hintText: 'e.g. Grilled Chicken Salad',
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Enter meal name'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Category',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<Category>(
                                value: _selectedCategory,
                                items: Category.values
                                    .map(
                                      (cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) =>
                                    setState(() => _selectedCategory = value),
                                validator: (value) => value == null
                                    ? 'Please select a category'
                                    : null,
                                decoration: const InputDecoration(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    //Description box
                    _box(
                      title: 'Description',
                      child: TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter description'
                            : null,
                      ),
                    ),
                    // Image URL field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Image URL (optional)',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _imageController,
                          decoration: const InputDecoration(
                            hintText: 'https://example.com/your_image.jpg',
                          ),
                          keyboardType: TextInputType.url,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              // Simple URL validation
                              final urlPattern = r'(http|https):\/\/([\w.]+\/?)\S*';
                              final result = RegExp(urlPattern, caseSensitive: false).hasMatch(value);
                              if (!result) return 'Please enter a valid URL';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    // Nutrition box
                    _box(
                      title: 'Nutrition',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Calories',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _calController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'e.g. 250',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Protein (g)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _proteinController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'e.g. 20',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Sugar (g)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _sugarController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'e.g. 8',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Fat (g)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _fatController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'e.g. 12',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Contain vegetables ?',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Switch(
                                value: _hasVegetables,
                                activeColor: cs.primary,
                                onChanged: (v) =>
                                    setState(() => _hasVegetables = v),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Ingredients box
                    _box(
                      title: 'Ingredients',
                      child: TextFormField(
                        controller: _ingredientsController,
                        decoration: const InputDecoration(
                          hintText:
                              'Comma separated (e.g. chicken, garlic, oil)',
                        ),
                      ),
                    ),
                    // Cooking steps box
                    _box(
                      title: 'Cooking Steps',
                      child: TextFormField(
                        controller: _instructionsController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Step by step cooking instructions',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Color(0xFFE85C5C)),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Color(0xFFE85C5C)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitMeal,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1F3A22),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Add'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
