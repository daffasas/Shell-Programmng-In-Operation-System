#!/bin/bash

case_folder()
{
    exact_hour=$(date +%H)
    # Storing jam saat ini ke variabel lain
    download_num=$((exact_hour))
    #  Variabel lain (download_num) digunakan untuk syarat soal dimana saat jam 00:00,
    #   tetap download 1 gambar
    if [ $exact_hour -eq 0 ]; then
        download_num=1
    else
        download_num=$exact_hour
    fi
    
    # Menggunakan grep, awk pada pembuatan increment pada penamaan folder kumpulan_NOMOR.FILE
    nama_folder="kumpulan_$(ls | grep -c '^kumpulan_[0-9]*$' | awk '{print $1+1}')"
    #membuat folder dengan ketentuan nama di atas
    mkdir $nama_folder
    
    # Mendownload gambar dan menyimpannya dengan format nama "perjalanan_NOMOR.FILE"
    for (( i=1; i<=$exact_hour; i=i+1 ));
    do
        #men-download file gambar dari API random generated images tentang indonesia (di sini saya gunakan wayang)
        wget "https://source.unsplash.com/600x400/?wayang" -O "${nama_folder}/perjalanan_${i}.FILE"
        
    done
}

# CRONJOBS untuk 2a (jalan setiap 10 jam sekali)
#  * */10 * * * /bin/bash /mnt/c/Users/daffa/OneDrive/Documents/DAFFA'S/tugsadas/SISOP/prak1no2/kobeni_liburan.sh case_folder

case_zip()
{
    zip_counter=$(ls | grep -c '^devil_[0-9]*$' | awk '{print $1+1}')
    folder_counter=$(ls | grep -c '^kumpulan_[0-9]*$' | awk '{print $1}')
    zip_name="/mnt/c/Users/daffa/OneDrive/Documents/DAFFA'S/tugsadas/SISOP/prak1no2/devil_${zip_counter}"
    
    for (( i=1; i <= folder_counter; i=i+1 ))
    do
        
        zip -r $zip_name.zip kumpulan_$i
        rm -r "/mnt/c/Users/daffa/OneDrive/Documents/DAFFA'S/tugsadas/SISOP/prak1no2/kumpulan_$i"
        
    done
}

# CRONJOBS untuk 2b (jalan setiap 24 jam sekali)
#   0 */24 * * * /bin/bash /mnt/c/Users/daffa/OneDrive/Documents/DAFFA'S/tugsadas/SISOP/prak1no2/kobeni_liburan.sh case_zip



if [ "$1" = "case_folder" ]; then
    case_folder
    #menjalankan case_folder jika ada new value case_folder
    elif [ "$1" = "case_zip" ]; then
    case_zip
    #menjalankan case_zip jika ada new value case_zip
fi

#$1 merupakan priority jika kita memasukkan new value di dalam command cronjob kita
#maka di sini karena di setiap cronjob pada setia case di assign value case_folder/case_zip
#itu akan otomatis masuk ke dalam algoritma if di bawah
