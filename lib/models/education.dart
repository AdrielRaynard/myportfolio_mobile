import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

/// Nilai [code] mengikuti pilihan yang tersimpan pada model Education di web.
@JsonEnum(valueField: 'code')
enum EducationLevel {
  smp('smp', 'SMP'),
  sma('sma', 'SMA/SMK'),
  s1('S1', 'S1 (Sarjana)'),
  s2('S2', 'S2 (Magister)'),
  s3('S3', 'S3 (Doktor)');

  const EducationLevel(this.code, this.label);

  final String code;
  final String label;

  String get shortLabel => switch (this) {
    smp || sma => label,
    s1 || s2 || s3 => code,
  };
}

/// Riwayat pendidikan sesuai EducationSerializer di Django.
@JsonSerializable(fieldRename: FieldRename.snake)
class Education {
  const Education({
    this.id,
    required this.schoolName,
    required this.level,
    required this.startYear,
    this.major,
    this.graduationYear,
    this.description = '',
    this.educationImageUrl = '',
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  @JsonKey(name: 'nama_sekolah')
  final String schoolName;
  @JsonKey(name: 'tingkat')
  final EducationLevel level;
  @JsonKey(name: 'jurusan')
  final String? major;
  @JsonKey(name: 'tahun_masuk')
  final int startYear;

  /// Kosong selama pendidikan masih berlangsung, sama seperti tahun_lulus di web.
  @JsonKey(name: 'tahun_lulus')
  final int? graduationYear;
  @JsonKey(name: 'deskripsi', defaultValue: '')
  final String description;
  @JsonKey(includeToJson: false)
  final String educationImageUrl;

  @JsonKey(includeToJson: false)
  final int starCount;
  @JsonKey(includeToJson: false)
  final bool isStarred;
  @JsonKey(includeToJson: false)
  final String starredByNames;

  Map<String, dynamic> toJson() => _$EducationToJson(this);
}
