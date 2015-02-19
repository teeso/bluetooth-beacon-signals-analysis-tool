clear;

global data_folder_path ;
data_folder_path = 'C:\ResearchCode\BT_SIGNAL_ANALYSIS\UK_Saeed_Studio_Data_Visualization\Raw_Data_UK_Saeed_Studio';

global AUS_floor_map_image_path ;
AUS_floor_map_image_path = 'C:\ResearchCode\BT_SIGNAL_ANALYSIS\UK_Saeed_Studio_Data_Visualization\Resources\Floor_Maps\UK_Saeed_Studio.png';

global BT_Icons_folder_path ;
BT_Icons_folder_path = 'C:\ResearchCode\BT_SIGNAL_ANALYSIS\UK_Saeed_Studio_Data_Visualization\Resources\BT_Icons\';

global Walking_direction_Icons_folder_path ;
Walking_direction_Icons_folder_path = 'C:\ResearchCode\BT_SIGNAL_ANALYSIS\UK_Saeed_Studio_Data_Visualization\Resources\Direction_Icons\'


% floor_map_image = imread(AUS_floor_map_image_path);
% imshow(floor_map_image);


BT_1_Icon_Location_BedroomDesk = [44, 90];
BT_2_Icon_Location_KitchenFridge = [200, 611];
BT_3_Icon_Location_BathroomCabinet = [62, 900];


BT_icon_location_list = [BT_1_Icon_Location_BedroomDesk,
                    BT_2_Icon_Location_KitchenFridge,
                    BT_3_Icon_Location_BathroomCabinet];
                

BT_icon_list = {'BT_Right.png', 
                'BT_Right.png', 
                'BT_Up.png'}

Walking_Direction_Icon_Location_P1_Up = [229, 21];
Walking_Direction_Icon_Location_P1_Down = [347, 926];
Walking_Direction_Icon_Location_P2_Left = [20, 171];
Walking_Direction_Icon_Location_P2_Right = [371, 319];
Walking_Direction_Icon_Location_P3_Left = [13, 726];
Walking_Direction_Icon_Location_P3_Right = [176, 810];            
            
            
walking_direction_icon_list = [Walking_Direction_Icon_Location_P1_Up,
                               Walking_Direction_Icon_Location_P1_Down,
                               Walking_Direction_Icon_Location_P2_Left,
                               Walking_Direction_Icon_Location_P2_Right,
                               Walking_Direction_Icon_Location_P3_Left,
                               Walking_Direction_Icon_Location_P3_Right];
             

walking_direction_icon_image_list = {'Walk_Up.png', 
                                     'Walk_Down.png', 
                                     'Walk_Left.png'
                                     'Walk_Right.png', 
                                     'Walk_Left.png', 
                                     'Walk_Right.png'};


Heat_Map_Location_P1_Up = [260, -140];
Heat_Map_Location_P1_Down = [310, -100 ];
Heat_Map_Location_P2_Left = [14, 213];
Heat_Map_Location_P2_Right = [370, 269];
Heat_Map_Location_P3_Left = [11, 753];
Heat_Map_Location_P3_Right = [181, 795 ];



heat_map_location_list = [Heat_Map_Location_P1_Up,
                          Heat_Map_Location_P1_Down,
                          Heat_Map_Location_P2_Left,
                          Heat_Map_Location_P2_Right,
                          Heat_Map_Location_P3_Left,
                          Heat_Map_Location_P3_Right];



heat_map_rotation_list = [270, 90, 0, 180, 0, 180]
heat_map_length_list = [1200, 1200,  850, 850, 500, 500]

[ folder_list, folder_path_list, number_of_folders ] = get_folder_list(data_folder_path);

for folder_index = 1:number_of_folders   
    heat_map_location_index = 1
    visualization_image_save_name = folder_list(folder_index);
    visualization_image_save_name = visualization_image_save_name{1}
    visualization_image_save_name = strcat(visualization_image_save_name , '.png')
    %floor_map_image = Load_Floor_Map('AUS'); 
    h = figure;
    floor_map_image = imread(AUS_floor_map_image_path);
    imshow(floor_map_image);
    hold on

    paint_BT_icon(BT_icon_list(folder_index),...        
                  BT_icon_location_list(folder_index,1),...     
                  BT_icon_location_list(folder_index,2));
    paint_all_direction_icons(walking_direction_icon_image_list,...
                              walking_direction_icon_list);
    
 folder_path = folder_path_list(folder_index,1);
    
    [ folder_list2, folder_path_list2, number_of_folders2 ] = get_folder_list(folder_path{1});

    for folder_index2 = 1:number_of_folders2  
        
        folder_path2 = folder_path_list2(folder_index2,1);
        [ file_list, number_of_files ] = get_file_list(folder_path2{1});
        file_index = 0;
        heat_map_gap = 0;
        while file_index < number_of_files
            % Create a variable to plot heats with a gap in parallel
            file_index = file_index + 1;
            filepath_1 = file_list(file_index,1);

            file_index = file_index + 1;
            filepath_2 = file_list(file_index,1);

            filepath_1 = char(filepath_1);
            filepath_2 = char(filepath_2);

        [ Raw_Data_Y1_transposed, Raw_Data_Y2_transposed ] = Data_Analyzer(filepath_1, filepath_2);
        %hmo = HeatMap(Raw_Data_Y1_transposed);
        %colormap('hot')
        
        
        
        paint_heat_map(Raw_Data_Y1_transposed,...
                       heat_map_rotation_list(heat_map_location_index),...
                       heat_map_length_list(heat_map_location_index),...
                       (heat_map_location_list(heat_map_location_index, 1) - heat_map_gap),...
                       heat_map_location_list(heat_map_location_index, 2));
                   
        heat_map_location_index_next = (heat_map_location_index + 1)
        
        paint_heat_map(Raw_Data_Y2_transposed,...
                       heat_map_rotation_list(heat_map_location_index_next),...
                       heat_map_length_list(heat_map_location_index_next),...
                       (heat_map_location_list(heat_map_location_index_next, 1) + heat_map_gap),...
                       heat_map_location_list(heat_map_location_index_next, 2));
                   
        heat_map_gap = heat_map_gap + 10;
        end
        heat_map_location_index = (heat_map_location_index + 1)
    end
    saveas(h, visualization_image_save_name,'png');
    close(h)
end
