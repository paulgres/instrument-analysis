    module modio
    
    
    use modmem
    
    implicit none
    private
    public::read_idx, write_fwf
    contains
    integer function num_records(filename)
    ! Return the number of records (lines) of a text file.
        character(len=*), intent(in) :: filename
        integer :: fileunit, i
        open(newunit=fileunit, file=filename)
        num_records = 0
        do
          read(unit=fileunit, fmt=*, end=11)
          num_records = num_records + 1
        end do
    11  continue
        close(unit=fileunit)
    end function num_records
    
    
    pure function FRSTNB(s)
        character(len=*), intent(in)::s
        integer :: frstnb
        integer::i
        frstnb=0
        do i=1,len(s)
            if (s(i:i)/=' ' .and. s(i:i)/='   ') then
                frstnb=i
                goto 111
            end if
            
        end do
111     continue        
    end function FRSTNB

    pure function int2str(i)result(res)
    integer, intent(in)::i
    
    character(21)::s
    character(:), allocatable::res
    write(s, '(I20)') i
    res = trim(adjustl(s))
    
    end function

    
    subroutine file_dim(filename,nr, nc, names)
        integer, intent(out):: nr,nc
        character(len=*), intent(in) :: filename
        character(len=:), allocatable, intent(out) :: names(:)
        character(len=9):: s(3000),t1,t2
        character(len=65000)::r
        integer :: fileunit, k, nk,i,l, l1
        nr=0
        nc=1
        open(newunit=fileunit, status='OLD', file=filename)
        do
            read(unit=fileunit, fmt='( a )', end=12) r
            nr = nr+1
            if (nr .eq. 1) then
               ! nc = count([ ( r(i:i), i = 1, len( r ) ) ] == ',') + 1
            nk = 0
            do 
                k=index(r(nk+1:),',' )
                if (k<1) goto 13
                
                    l1=index(r(nk+k+1:), " ")
                    
                    l=index(r(nk+k+l1+1:), " ")+l1
                    s(nc)=r(nk+k+1:nk+k+l1-1)// "_" //r(nk+k+l1+1:nk+k+l-1)
                
                
                nk=nk+k
                nc=nc+1
                  
                  
            end do
13          continue              
                  
            end if
        end do
12      continue
        close(unit=fileunit)
        if (nc>1) allocate(names, source = s(1:nc-1))
    end subroutine file_dim
    
    subroutine fwf_dim(filename,nr, nc, names)
        integer, intent(out):: nr,nc
        character(len=*), intent(in) :: filename
        character(len=:), allocatable, intent(out) :: names(:)
        character(len=9):: s(3000),t1,t2
        character(len=55*1024)::r
        integer :: fileunit, k, nk,i,l, l1
        nr=0
        nc=0
        open(newunit=fileunit, status='OLD', file=filename)
        read(unit=fileunit, fmt='( a )', end=12) r
        nr=1
        nk=1
        do
            k=frstnb(r(nk:))
            if (k<1) goto 15
            nc=nc+1
            l=index(r(nk+k:), ' ')+k
            if (l .eq. k) then
                s(nc)=r(nk+k-1:)
                goto 15
            end if
        
            s(nc)=r(nk+k-1:nk+l-1)
            
            nk=nk+l
        end do
15      continue        
        do
            read(unit=fileunit, fmt='( a )', end=12) 
            nr = nr+1
            
        end do
12      continue
        close(unit=fileunit)
        if (nc>1) allocate(names, source = s(2:nc))
    end subroutine fwf_dim
    
    
    subroutine write_fwf(filename, date, names, matrix)
        character(len=*),intent(in)::filename
        character(len=:), allocatable, intent(in ) :: date(:), names(:)
        character(50)::fmt1, fmt2
        real, allocatable, intent(in) :: matrix(:,:)
        real, allocatable::m(:,:)
        integer::i, f, sm(2),n
        sm=shape(matrix)
        n=sm(2)
        
        fmt1 = '(a10,'//int2str(n)//'a20)'
        fmt2 = '(a10,'//int2str(n)//'(1x,ES19.12))'
        m=transpose(matrix)
        open(newunit=f, file=filename)
        write (f, fmt=fmt1, err=500) 'DATE      ', names
        do i=1,size(date)
            write (f, fmt=fmt2, err=500)date(i),m(:,i)
        end do
500     continue
        close(f)
        deallocate(m)
    end subroutine write_fwf
    
    subroutine write_fwf_logi(filename, date, names, matrix)
        character(len=*),intent(in)::filename
        character(len=:), allocatable, intent(in ) :: date(:), names(:)
        logical, allocatable, intent(in) :: matrix(:,:)
        logical, allocatable::m(:,:)
        character(50)::fmt1, fmt2
        integer::i, f,n,sm(2)
        sm=shape(matrix)
        n=sm(2)
        fmt1 = '(a10,'//int2str(n)//'a8)'
        fmt2 = '(a10,'//int2str(n)//'l8)'
        m=transpose(matrix)
        open(newunit=f, file=filename)
        write (f, fmt=fmt1, advance="no", err=501) 'date      ',names
        
        do i=1,size(date)
            write (f, fmt=fmt2, advance="no", err=501)date(i),m(:,i)
        
        end do
    
501     continue
        close(f)
        deallocate(m)
    end subroutine write_fwf_logi
    
    
    
    subroutine read_idx(filename, date, names, matrix, csv, stat, errmsg)
        logical, intent(in), optional::csv
        logical::csv1=.False.
        character(len=*), intent(in) :: filename
        character(len=:), allocatable, intent(in out) :: date(:), names(:)
        real, allocatable, intent(in out) :: matrix(:,:)
        real, allocatable::m(:,:)
        character(20)::s
        character(100), optional, intent(inout)::errmsg
        integer, optional, intent(inout)::stat
        integer :: fileunit, n, nr, nc, nrm, ncm
        
        if (present(csv)) then
            csv1=csv
        end if 
        if (csv1) then
            call file_dim(filename, nr,nc,names)
        else
            call fwf_dim(filename, nr,nc,names)
        end if
        if ((nc .lt. 2) .or. (nr .lt. 2) ) then
            if (present(stat)) stat = -1
            if (present(errmsg)) errmsg = "ERROR: The input file "//trim(filename)//" did not yeald meaningful data."
             goto 42
        end if 
        ncm = nr-1
        nrm = nc-1
        if (allocated(date)) deallocate(date)
        allocate(character(len=10) :: date(nr-1))
        call allocm(m, nrm,ncm)
        open(newunit=fileunit, status='OLD', file=filename)
        read(fileunit, fmt=*, end=41) !discard the first row
        do n = 1, nr-1
          read(fileunit, fmt=*, end=41) date(n), m(:nrm,n)
        end do
        if(allocated(matrix))deallocate(matrix)
        matrix=transpose(m)
        call freem(m)
        if (present(stat)) stat = 0
41      close(fileunit)
        
42      continue
    end subroutine read_idx

    
    end module modio