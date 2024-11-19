import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../models/product.dart';
import '../providers/products.dart';

class AddNewProductsScreen extends StatefulWidget {
  const AddNewProductsScreen({super.key});

  static const routeName = '/add-product-screen';

  @override
  State<AddNewProductsScreen> createState() => _AddNewProductsScreenState();
}

class _AddNewProductsScreenState extends State<AddNewProductsScreen> {
  final _form = GlobalKey<FormState>();
  final _mainImageForm = GlobalKey<FormState>();
  var isCheck = false;
  Color initColor = Colors.black;

  var _product = Product(
    id: '',
    title: '',
    imgUrl: [''],
    ingredients: '',
    quality: '',
    discount: 0,
    price: 0.0,
    color: Colors.black,
  );

  void selectColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          title: const Text('Orqa fonga rang tanlang!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: initColor,
              onColorChanged: (value) {
                setState(() {
                  initColor = value;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'BEKOR QILISH',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _product.color = initColor;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'QABUL QILISH',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  var init = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        final editingProduct =
            Provider.of<Products>(context).findById(productId as String);
        setState(() {
          _product = editingProduct;
        });
      }
    }
    init = false;
  }

  var _hasImage = true;

  void _saveForm() {
    FocusScope.of(context).unfocus();
    final isValidated = _form.currentState!.validate();
    setState(() {
      _hasImage = _product.imgUrl.isNotEmpty;
    });
    if (isValidated && _hasImage) {
      _form.currentState!.save();
      if (_product.id.isEmpty) {
        Provider.of<Products>(context, listen: false).addNewProduct(_product);
      } else {
        Provider.of<Products>(context, listen: false).updateProduct(_product);
      }
      Navigator.of(context).pop();
    }
  }

  void _saveImageForm() {
    FocusScope.of(context).unfocus();
    final imageValidated = _mainImageForm.currentState!.validate();
    if (imageValidated) {
      _mainImageForm.currentState!.save();
      setState(() {
        _hasImage = true;
      });
      Navigator.of(context).pop();
    }
  }

  void openMainImageInput(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          title: const Text('Asosiy rasm linkini kiriting'),
          content: Form(
            key: _mainImageForm,
            child: TextFormField(
              initialValue: _product.imgUrl[0],
              decoration: const InputDecoration(
                label: Text('Rasm URL'),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.amber,
                  ),
                ),
              ),
              onSaved: (newValue) {
                _product = Product(
                  id: _product.id,
                  title: _product.title,
                  imgUrl: [newValue!],
                  ingredients: _product.ingredients,
                  quality: _product.quality,
                  discount: _product.discount,
                  price: _product.price,
                  color: _product.color,
                  isLike: _product.isLike,
                );
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mahsulot rasmini kiriting!';
                } else if (!value.startsWith('http')) {
                  return 'Mahsulot rasmini to\'g\'ri formatda kiring';
                } else if (!value.startsWith('https')) {
                  return 'Mahsulot rasmini to\'g\'ri formatda kiring';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'BEKOR QILISH',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: _saveImageForm,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'QABUL QILISH',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahsulot qo\'shish'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _product.title,
                  decoration: const InputDecoration(
                    label: Text('Nomi'),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  onSaved: (newValue) {
                    _product = Product(
                      id: _product.id,
                      title: newValue!,
                      imgUrl: _product.imgUrl,
                      ingredients: _product.ingredients,
                      quality: _product.quality,
                      discount: _product.discount,
                      price: _product.price,
                      color: _product.color,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, Mahsulot nomini kiriting!';
                    } else if (value.length < 3) {
                      return 'Mahsulot nomini to\'liq kiriting';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _product.price == 0.0
                      ? ''
                      : _product.price.toStringAsFixed(2),
                  decoration: const InputDecoration(
                    label: Text('Narxi'),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSaved: (newValue) {
                    _product = Product(
                      id: _product.id,
                      title: _product.title,
                      imgUrl: _product.imgUrl,
                      ingredients: _product.ingredients,
                      quality: _product.quality,
                      discount: _product.discount,
                      price: double.parse(newValue!),
                      color: _product.color,
                      isLike: _product.isLike,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, Mahsulot narxini kiriting!';
                    } else if (double.tryParse(value) == null) {
                      return 'Mahsulot narxini raqamda kiriting';
                    } else if (double.parse(value) <= 0) {
                      return 'Mahsulot narxi 0 yoki 0 dan katta bo\'lishi shart';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _product.ingredients,
                  decoration: const InputDecoration(
                    label: Text('Tarifi'),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                      ),
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  onSaved: (newValue) {
                    _product = Product(
                      id: _product.id,
                      title: _product.title,
                      imgUrl: _product.imgUrl,
                      ingredients: newValue!,
                      quality: _product.quality,
                      discount: _product.discount,
                      price: _product.price,
                      color: _product.color,
                      isLike: _product.isLike,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, Mahsulotga tarif bering!';
                    } else if (value.length < 8) {
                      return 'Mahsulot tarifini batafsil kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _product.discount.toString(),
                  decoration: const InputDecoration(
                    label: Text('Chegirma %'),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (newValue) {
                    _product = Product(
                      id: _product.id,
                      title: _product.title,
                      imgUrl: _product.imgUrl,
                      ingredients: _product.ingredients,
                      quality: _product.quality,
                      discount: int.parse(newValue!),
                      price: _product.price,
                      color: _product.color,
                      isLike: _product.isLike,
                    );
                  },
                  validator: (value) {
                    if (int.tryParse(value!) == null) {
                      return 'Iltimos, Mahsulot chegirmasini raqamda kiriting!';
                    } else if (int.parse(value) > 100) {
                      return 'Mahsulot chegirmasi faqat 100% dan kam bo\'lishi lozim!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text('Mahsulot yangimi:'),

                    // Container(
                    //   width: 12,
                    //   height: 12,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: Colors.black,
                    //     ),

                    //   ),
                    // ),
                    _product.quality.isEmpty
                        ? Checkbox(
                            value: isCheck,
                            onChanged: (value) {
                              setState(() {
                                isCheck = value!;
                                if (isCheck) {
                                  _product.quality = 'New';
                                } else {
                                  _product.quality = '';
                                }
                              });
                            },
                            checkColor: Colors.white,
                            activeColor: Colors.amber,
                          )
                        : Checkbox(
                            value: isCheck = true,
                            onChanged: (value) {
                              setState(() {
                                isCheck = value!;
                                if (isCheck) {
                                  _product.quality = 'New';
                                } else {
                                  _product.quality = '';
                                }
                              });
                            },
                            checkColor: Colors.white,
                            activeColor: Colors.amber,
                          )
                  ],
                ),
                Row(
                  children: [
                    const Text('Orqa fon rangini tanlang:'),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        selectColor(context);
                      },
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              color: _product.color == Colors.transparent
                                  ? Colors.black
                                  : _product.color,
                              spreadRadius: 0.1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () => openMainImageInput(context),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _hasImage ? Colors.grey : Colors.red,
                      ),
                    ),
                    child: _product.imgUrl[0].isEmpty
                        ? Text(
                            'Asosiy rasm linkini qoying (PNG formatda!)',
                            style: TextStyle(
                              color: _hasImage ? Colors.grey : Colors.red,
                            ),
                          )
                        : _product.imgUrl[0].startsWith('http')
                            ? Image.network(
                                _product.imgUrl[0],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Image.asset(
                                _product.imgUrl[0],
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // const Text('Qo\'shimcha rasmlarni qoying'),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     FirstImageDetails(_product,_saveForm,),
                //     SecondImageDetails(_product, _saveForm),
                //     ThirdImageDetails(_product, _saveForm),
                //     FourthImageDetails(_product, _saveForm),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
