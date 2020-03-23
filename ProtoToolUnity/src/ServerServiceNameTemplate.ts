import _fs = require("fs");
const fs: typeof _fs = nodeRequire("fs");

const IServiceNameReg = /interface\s*IServiceName\s*[{]([^]+)[}]/g;
const ServiceItem = /([/][*][^]+?[*][/])?\s+([a-zA-Z_0-9]+)\s*?:\s*string;/g;
// 查找是否有ServiceName.${key}
const regValue = /ServiceName[.]([a-zA-Z_0-9]+)\s*=\s*"([a-zA-Z_0-9]+)";/g;

/**
 * 
 * 用于创建ServiceName的常量文件
 * @export
 * @class ServerServiceNameTemplate
 */
export default class ServerServiceNameTemplate {
    public addToFile(file: string, key: string) {
        let interfaceDic: Map<string, string> = new Map();
        let valueDic: Map<string, string> = new Map();
        if (!fs.existsSync(file) || !fs.statSync(file).isFile()) {
            return [null, this.addContent(key, interfaceDic, valueDic)];
        }
        let content = fs.readFileSync(file, "utf8");
        IServiceNameReg.lastIndex = 0;
        let resCK = IServiceNameReg.exec(content);
        // 检查ConfigKey常量
        if (resCK) {
            let cfgs = resCK[1];
            ServiceItem.lastIndex = 0;
            while (true) {
                let res = ServiceItem.exec(cfgs);
                if (res) {
                    interfaceDic.set(res[2], res[0].trim());
                } else {
                    break;
                }
            }
        }
        regValue.lastIndex = 0;
        while (true) {
            let res = regValue.exec(content);
            if (res) {
                valueDic.set(res[1], res[2]);
            } else {
                break;
            }
        }
        return [null, this.addContent(key, interfaceDic, valueDic)];
    }

    private addContent(key: string, interfaceDic: Map<string, string>, valueDic: Map<string, string>) {
        let added = false;
        let code = `interface IServiceName {\n`;
        for (let k of interfaceDic.keys()) {
            if (k == key) {
                added = true;
            }
            code += `\t${interfaceDic.get(k)}\n`;
        }
        if (!added) {
            code += `\t${key}: string;\n`;
        }
        code += "}\n";
        added = false;

        for (let k of valueDic.keys()) {
            if (k == key) {
                added = true;
            }
            code += `ServiceName.${k} = "${valueDic.get(k)}";\n`;
        }
        if (!added) {
            code += `ServiceName.${key} = "${key}";\n`;
        }
        return code;
    }
}

