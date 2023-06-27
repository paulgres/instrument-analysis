module instrument_analysis
  implicit none
  private

  public :: say_hello
contains
  subroutine say_hello
    print *, "Hello, instrument-analysis!"
  end subroutine say_hello
end module instrument_analysis
