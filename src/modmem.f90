    module modmem
    implicit none
    private
    public ::alloc, allocm, freea, freem
    contains
    
    subroutine allocm(a, n,m)
        real, allocatable, intent(in out) :: a(:, :)
        integer, intent(in) :: n,m
        integer :: stat
        character(len=100) :: errmsg
        if (allocated(a)) call freem(a)
        allocate(a(n,m), stat=stat, errmsg=errmsg)
        if (stat > 0) error stop errmsg
    end subroutine allocm
    
    subroutine alloc(a, n)
        real, allocatable, intent(in out) :: a(:)
        integer, intent(in) :: n
        integer :: stat
        character(len=100) :: errmsg
        if (allocated(a)) call freea(a)
        allocate(a(n), stat=stat, errmsg=errmsg)
        if (stat > 0) error stop errmsg
    end subroutine alloc

    subroutine freea(a)
        real, allocatable, intent(in out) :: a(:)
        integer :: stat
        character(len=100) :: errmsg
        if (.not. allocated(a)) return
        deallocate(a, stat=stat, errmsg=errmsg)
        if (stat > 0) error stop errmsg
    end subroutine freea
    
    subroutine freem(a)
        real, allocatable, intent(in out) :: a(:,:)
        integer :: stat
        character(len=100) :: errmsg
        if (.not. allocated(a)) return
        deallocate(a, stat=stat, errmsg=errmsg)
        if (stat > 0) error stop errmsg
    end subroutine freem
    
    end module modmem