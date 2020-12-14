class Exceptions{
  static String show(String exceptionCode){
    switch(exceptionCode){
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "Bu mail adresi kullanılıyor, lütfen farklı mail kullanınız";
      case 'ERROR_USER_NOT_FOUND':
        return 'Bu kulanıcı sistemde bulunmamaktadır. Lütfen önce kullanıcı oluşturunuz!';
      default :
        return 'Bir hata oluştu';
    }
  }
}