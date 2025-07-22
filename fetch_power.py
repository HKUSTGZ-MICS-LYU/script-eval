import os
import re
from collections import defaultdict

def find_report_power_files(root_dir):
    """查找所有以report_power为后缀的文件"""
    report_power_files = []
    for root, _, files in os.walk(root_dir):
        for file in files:
            if file.endswith('report_power'):
                report_power_files.append(os.path.join(root, file))
    return report_power_files

def extract_power_data(file_path):
    """从文件中提取Corner和Total Dynamic Power数据"""
    corner_pattern = re.compile(r'Corner:\s*(\S+)')
    power_pattern = re.compile(r'Total Dynamic Power\s*=\s*(\S+)\s+nW')
    
    corners = []
    powers = []
    
    with open(file_path, 'r') as f:
        for line in f:
            corner_match = corner_pattern.search(line)
            power_match = power_pattern.search(line)
            
            if corner_match:
                corners.append(corner_match.group(1))
            if power_match:
                powers.append(power_match.group(1))
    
    # 确保我们只取前三个corner和对应的power
    corners = corners[:3]
    powers = powers[:3]
    
    # 如果corner和power数量不匹配，只保留匹配的部分
    min_len = min(len(corners), len(powers))
    corners = corners[:min_len]
    powers = powers[:min_len]
    
    return corners, powers

def process_files(input_dir, output_file):
    """处理所有文件并输出结果"""
    report_files = find_report_power_files(input_dir)
    
    with open(output_file, 'w') as out_f:
        # 写入表头
        out_f.write("File Path,Corner1,Power1,Corner2,Power2,Corner3,Power3\n")
        
        for file_path in report_files:
            corners, powers = extract_power_data(file_path)
            
            # 准备输出行
            output_line = [file_path]
            
            # 确保最多有三个corner-power对
            for i in range(3):
                if i < len(corners):
                    output_line.append(corners[i])
                else:
                    output_line.append("")
                
                if i < len(powers):
                    output_line.append(powers[i])
                else:
                    output_line.append("")
            
            # 写入输出文件
            out_f.write(",".join(output_line) + "\n")

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description='Extract power data from report_power files')
    parser.add_argument('input_dir', help='Directory to search for report_power files')
    parser.add_argument('output_file', help='Output CSV file path')
    
    args = parser.parse_args()
    
    process_files(args.input_dir, args.output_file)
    print(f"Processing complete. Results saved to {args.output_file}")
