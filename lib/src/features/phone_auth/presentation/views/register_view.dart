import 'dart:io';

import 'package:awesome_place_search/awesome_place_search.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:vivamais/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vivamais/src/features/auth/presentation/cubit/auth_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../../app/app_entity.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/theme/color_palette.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_values.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../../user/presentation/cubit/register_cubit/register_cubit.dart';
import '../../../user/presentation/cubit/register_cubit/register_state.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';

class RegisterView extends StatefulWidget {
  final PhoneController phoneNumber;
  const RegisterView({super.key, required this.phoneNumber});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController firstName = TextEditingController();

  TextEditingController lastName = TextEditingController();

  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  DateTime birth = DateTime.now();
  TextEditingController birthText = TextEditingController();
  TextEditingController nascimento = TextEditingController();
  TextEditingController blood = TextEditingController();
  TextEditingController phone = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  bool is_donor = false;
  TextEditingController controller = TextEditingController();
  TextEditingController locationHospital = TextEditingController();
  PredictionModel? prediction;
  late UserCubit userCubit;

  PhoneController _phoneController = PhoneController(null);

  final _formKey = GlobalKey<FormBuilderState>();
  List<String> genders = ["Masculino", "Femenino"];
  String get apiKey => dotenv.env['ANDROID_GOOGLE_API_KEY'] ?? '';
  List<String> bloods = [
    "A+",
    "B+",
    "AB-",
    "A-",
    "O-",
    "AB+",
    "O+",
    "B-",
  ];

  Widget bloodIcon = Icon(FontAwesomeIcons.tint);

  XFile? image;

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      image = imageFile;
    });
    //setState(() => _isLoading = true);
  }

  Future<void> removeImage() async {
    setState(() {
      image = null;
    });
    //setState(() => _isLoading = true);
  }

  void bloodSvg(String blood) {
    switch (blood) {
      case "A+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.ap,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;

      case "B+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.bp,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;
      case "AB-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.abn,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;
      case "A-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.an,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;
      case "O-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.oN,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      case "AB+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.ab,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      case "O+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.op,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      case "B-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.b,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      default:
        setState(() {
          bloodIcon = Icon(
            FontAwesomeIcons.tint,
            color: AppColors.primaryColor,
          );
        });
    }
  }

  Widget svgBlood(String blood) {
    switch (blood) {
      case "A+":
        return SvgPicture.asset(
          AppIcons.ap,
          color: AppColors.primaryColor,
        );

      case "B+":
        return SvgPicture.asset(
          AppIcons.bp,
          color: AppColors.primaryColor,
        );
      case "AB-":
        return SvgPicture.asset(
          AppIcons.abn,
          color: AppColors.primaryColor,
        );
      case "A-":
        return SvgPicture.asset(
          AppIcons.an,
          color: AppColors.primaryColor,
        );
      case "O-":
        return SvgPicture.asset(
          AppIcons.oN,
          color: AppColors.primaryColor,
        );
      case "AB+":
        return SvgPicture.asset(
          AppIcons.ab,
          color: AppColors.primaryColor,
        );
      case "O+":
        return SvgPicture.asset(
          AppIcons.op,
          color: AppColors.primaryColor,
        );
      case "B-":
        return SvgPicture.asset(
          AppIcons.b,
          color: AppColors.primaryColor,
        );
      default:
        return Icon(
          FontAwesomeIcons.tint,
          color: AppColors.primaryColor,
        );
    }
  }

  void verifyUserProfile() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: "userProfile", value: "0");
  }

  void _searchPlaces() {
    AwesomePlaceSearch(
      context: context,
      apiKey: apiKey,
      countries: ["ao"],
      errorText: "Ouve um erro, tente novamente mais tarde",
      hint: "Buscar por uma localização",
      dividerItemColor: Colors.grey.withOpacity(.5),
      dividerItemWidth: .5,
      elevation: 5,
      indicatorColor: Colors.blue,
      modalBorderRadius: 50.0,
      onTap: (value) async {
        final result = await value;

        setState(() {
          locationHospital.text = result.description!;
          prediction = result;
        });
      },
    ).show();
  }

  @override
  void initState() {
    phone.text = "+${widget.phoneNumber}";
    _phoneController = widget.phoneNumber;

    print("NÚMERO");
    print(widget.phoneNumber.value!.countryCode);
    print(widget.phoneNumber.value!.nsn);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.register),
        ),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterLoading) {
              // ProgressDialog progressDialog = ProgressDialog(
              //   context,
              //   blur: 5,
              //   title: SizedBox.shrink(),
              //   message: Text("Registando.."),
              //   onDismiss: () => print("Do something onDismiss"),
              // );
              // progressDialog.show();
            } else if (state is RegisterSuccess) {
              _btnController.stop();
              verifyUserProfile();
              Navigator.of(context).pushNamed(Routes.vivaMaisRoute);
            } else if (state is AuthError) {
              Navigator.of(context).pop();
              DialogBackground(
                blur: 5,
                dialog: AlertDialog(
                  title: Text(
                    "Error",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  content: Text("${state}"),
                  actions: <Widget>[
                    TextButton(
                        child: Text("Fechar"),
                        onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ).show(context);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(AppPadding.p16),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Text(
                        //   AppStrings.createAccount,
                        //   style: Theme.of(context).textTheme.headlineSmall,
                        // ),
                        // SizedBox(
                        //   height: AppSize.s10,
                        // ),
                        Stack(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.strokeColor,
                                ),
                              ),
                              child: (image == null)
                                  ? Icon(
                                      Icons.add_a_photo_outlined,
                                      color: AppColors.secondaryTextColor,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                        File(image!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: (image == null)
                                  ? InkWell(
                                      onTap: uploadImage,
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                            width: 2,
                                            color: AppColors.strokeColor,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.image,
                                          size: 20,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: removeImage,
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                            width: 2,
                                            color: AppColors.strokeColor,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: AppSize.s20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: "first name",
                                controller: firstName,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  hintText: "Primeiro Nome",
                                  suffixIcon: Icon(
                                    Icons.person,
                                  ),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Campo obrigatório",
                                  ),
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: "last name",
                                controller: lastName,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  hintText: "Último Nome",
                                  suffixIcon: Icon(
                                    Icons.person,
                                  ),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Campo obrigatório",
                                  ),
                                ]),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: AppSize.s12,
                        ),

                        PhoneFormField(
                          validator: PhoneValidator.compose([
                            // list of validators to use
                            PhoneValidator.required(
                                errorText: "Telefone obrigatório"),
                            PhoneValidator.validMobile(
                                errorText: "Número inválido"),
                            // ..
                          ]),
                          controller: _phoneController,
                          defaultCountry: IsoCode.AO,
                          decoration: const InputDecoration(
                            filled: true,
                            contentPadding: EdgeInsets.only(
                                left: AppPadding.p10, top: AppPadding.p10),
                            border: InputBorder.none,
                            hintText: AppStrings.phone,
                            fillColor: AppColors.primaryColor20,
                          ),
                          countrySelectorNavigator:
                              const CountrySelectorNavigator.searchDelegate(),
                          onChanged: (phoneNumber) async {},
                          enabled: false,
                          isCountrySelectionEnabled: false,
                          showFlagInInput: true,
                          onSubmitted: (value) {
                            print(value);
                          },
                        ),

                        SizedBox(
                          height: AppSize.s12,
                        ),
                        FormBuilderTextField(
                          name: "email",
                          controller: email,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "E-mail",
                            suffixIcon: Icon(
                              Icons.mail,
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.email(
                                errorText: "E-mail inválido"),
                            FormBuilderValidators.required(
                                errorText: "E-mail obrigatório"),
                          ]),
                        ),
                        SizedBox(
                          height: AppSize.s12,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FormBuilderDropdown<String>(
                                name: 'gender',
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  hintText: 'Gênero',
                                  suffixIcon: Icon(
                                    Icons.man,
                                  ),
                                ),
                                items: genders
                                    .map((gender) => DropdownMenuItem(
                                          value: gender,
                                          child: Text(gender),
                                        ))
                                    .toList(),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: "Gênero obrigatório"),
                                ]),
                                onChanged: (value) {
                                  print(value);
                                  gender.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: FormBuilderDateTimePicker(
                                name: 'birth',
                                controller: birthText,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                format: DateFormat('yyyy-MM-dd'),
                                inputType: InputType.date,
                                initialEntryMode: DatePickerEntryMode.calendar,
                                decoration: InputDecoration(
                                  hintText: "Nascimento",
                                  suffixIcon: Icon(
                                    Icons.calendar_month_rounded,
                                  ),
                                ),
                                onChanged: (value) {
                                  birth = value!;
                                },
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: "Nascimento obrigatório"),
                                ]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppSize.s12,
                        ),

                        Container(
                          // margin:
                          //     EdgeInsets.symmetric(horizontal: AppMargin.m15),
                          child: TextFormField(
                            controller: locationHospital,
                            onTap: () {
                              _searchPlaces();
                            },
                            readOnly: true,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: "Campo obrigatório"),
                            ]),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(left: AppSize.s10),
                              hintText: 'Localização',
                              suffixIcon: Icon(Icons.location_on_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppSize.s12,
                        ),
                        FormBuilderDropdown<String>(
                          name: 'blood',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            //labelText: 'Grupo Sangíneo',
                            hintText: 'Grupo Sangíneo',
                            suffixIcon: bloodIcon,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Grupo Sanguíneo obrigatório"),
                          ]),
                          items: bloods.map((bloodGroup) {
                            return DropdownMenuItem(
                              value: bloodGroup,
                              child: Text(bloodGroup),
                            );
                          }).toList(),
                          onChanged: (groupBlood) {
                            svgBlood(groupBlood!);
                            print(groupBlood);
                            blood.text = groupBlood;
                          },
                        ),

                        SizedBox(
                          height: AppSize.s12,
                        ),
                        FormBuilderCheckbox(
                          name: 'donor',
                          title: Text(
                            "Registar como doador",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          contentPadding: EdgeInsets.all(0),
                          checkColor: AppColors.whiteColor,
                          activeColor: AppColors.primaryColor,
                          selected: true,
                          onChanged: (value) {
                            is_donor = value!;
                          },
                        ),
                        SizedBox(
                          height: AppSize.s12,
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     print(firstName.text);
                        //     print(lastName.text);
                        //     //print(phone.value!.nsn);
                        //     print(email.text);
                        //     print(birthText.text);
                        //     print(gender.text);
                        //     print(blood.text);
                        //     print(is_donor);

                        //     Navigator.pushNamed(context, Routes.otpRoute);

                        // if (_formKey.currentState!.validate()) {
                        //   final user = UserEntity(
                        //     firstName: firstName.text,
                        //     lastName: lastName.text,
                        //     password: "123456SS7",
                        //     phone: phone.value!.nsn,
                        //     email: email.text,
                        //     avatar_url: "aaaaa",
                        //     gender: gender.text,
                        //     blood: blood.text,
                        //     is_donor: is_donor,
                        //     birth: DateTime.parse(birthText.text),
                        //   );
                        //   if (image == null) {
                        //     BlocProvider.of<AuthCubit>(context)
                        //         .register(user, null);
                        //   } else {
                        //     BlocProvider.of<AuthCubit>(context)
                        //         .register(user, File(image!.path));
                        //   }
                        //     // }
                        //   },
                        //   child: Text(AppStrings.keepingOn),
                        // ),
                        RoundedLoadingButton(
                          color: AppColors.primaryColor,
                          successColor: AppColors.green,
                          child: Text(AppStrings.keepingOn,
                              style: TextStyle(color: Colors.white)),
                          controller: _btnController,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final user = UserEntity(
                                firstName: firstName.text,
                                lastName: lastName.text,
                                password: "",
                                phone:
                                    "${widget.phoneNumber.value!.countryCode} ${widget.phoneNumber.value!.nsn}",
                                email: email.text,
                                avatar_url: "",
                                gender: gender.text,
                                isValiable: true,
                                blood: blood.text,
                                address: locationHospital.text,
                                latitude: prediction!.latitude,
                                longitude: prediction!.longitude,
                                is_donor: is_donor,
                                birth: DateTime.parse(birthText.text),
                              );

                              if (image == null) {
                                BlocProvider.of<RegisterCubit>(context)
                                  ..createUser(user);
                              } else {
                                BlocProvider.of<RegisterCubit>(context)
                                  ..createUser(user, image: File(image!.path));
                              }
                            } else {
                              _btnController.stop();
                            }
                          },
                        ),

                        SizedBox(
                          height: AppSize.s12,
                        ),
                        // RichText(
                        //   text: TextSpan(
                        //     style: Theme.of(context).textTheme.bodyMedium,
                        //     children: [
                        //       TextSpan(text: "Já tem uma conta? "),
                        //       TextSpan(
                        //         text: "Login",
                        //         style: TextStyle(
                        //           color: AppColors.primaryColor,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: AppSize.s12,
                        // ),
                        // Text(
                        //   "Pesquisa Rápida",
                        //   style: TextStyle(
                        //     decoration: TextDecoration.underline,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
