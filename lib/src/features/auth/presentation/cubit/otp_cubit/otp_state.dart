abstract class OtpState {}

class OtpInitial implements OtpState {}

class OtpConfirmed implements OtpState {
  const OtpConfirmed();
}

class OtpLoading implements OtpState {}

class UnOtpenticated implements OtpState {}

class OtpError implements OtpState {
  OtpError();
}
